//
//  SimpleViewController.swift
//  FlagPhoneNumber_Example
//
//  Created by Aurelien on 24/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FlagPhoneNumber

private var phoneUtil: NBPhoneNumberUtil = NBPhoneNumberUtil()

extension String {
    
    func getNewFormattedPhoneNumber(format: FPNFormat) -> String? {
        
        let cleanedPhoneNumber: String = clean(string: self)
        
        if let validPhoneNumber = getValidNumber(phoneNumber: cleanedPhoneNumber) {
            let newTemp = try? phoneUtil.format(validPhoneNumber, numberFormat: .INTERNATIONAL)
            print(newTemp!)
        }
        
        return ""
    }
    
    func clean(string: String) -> String {
        var allowedCharactersSet = CharacterSet.decimalDigits
        allowedCharactersSet.insert("+")
        return string.components(separatedBy: allowedCharactersSet.inverted).joined(separator: "")
    }
    
    func getValidNumber(phoneNumber: String) -> NBPhoneNumber? {
        let countryCode = FPNCountryCode.US
        do {
            let parsedPhoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNumber, defaultRegion: countryCode.rawValue)
            let isValid = phoneUtil.isValidNumber(parsedPhoneNumber)
            return isValid ? parsedPhoneNumber : nil
        } catch _ {
            return nil
        }
    }
}

class SimpleViewController: UIViewController {

	@IBOutlet weak var phoneNumberTextField: FPNTextField!

	var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

	override func viewDidLoad() {
		super.viewDidLoad()

        let str = "+919979306224"
        str.getNewFormattedPhoneNumber(format: .International)
        
		title = "In Simple View"

		view.backgroundColor = UIColor.groupTableViewBackground

		// To use your own flag icons, uncommment the line :
		//		Bundle.FlagIcons = Bundle(for: SimpleViewController.self)

		phoneNumberTextField.borderStyle = .roundedRect
//		phoneNumberTextField.pickerView.showPhoneNumbers = false
		phoneNumberTextField.displayMode = .list // .picker by default

		listController.setup(repository: phoneNumberTextField.countryRepository)

		listController.didSelect = { [weak self] country in
			self?.phoneNumberTextField.setFlag(countryCode: country.code)
		}

		phoneNumberTextField.fpnDelegate = self
		phoneNumberTextField.font = UIFont.systemFont(ofSize: 14)

		// Custom the size/edgeInsets of the flag button
		phoneNumberTextField.flagButtonSize = CGSize(width: 35, height: 35)
		phoneNumberTextField.flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

		// Example of customizing the textField input accessory view
		let items = [
			UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: nil),
			UIBarButtonItem(title: "Item 1", style: .plain, target: self, action: nil),
			UIBarButtonItem(title: "Item 2", style: .plain, target: self, action: nil)
		]
		phoneNumberTextField.textFieldInputAccessoryView = getCustomTextFieldInputAccessoryView(with: items)

		// The placeholder is an example phone number of the selected country by default. You can add your own placeholder :
		phoneNumberTextField.hasPhoneNumberExample = true
		phoneNumberTextField.placeholder = "Phone Number"

		// Set the country list
		//		phoneNumberTextField.setCountries(including: [.ES, .IT, .BE, .LU, .DE])

		// Exclude countries from the list
		//		phoneNumberTextField.setCountries(excluding: [.AM, .BW, .BA])

		// Set the flag image with a region code
		phoneNumberTextField.setFlag(countryCode: .FR)

		// Set the phone number directly
//		phoneNumberTextField.set(phoneNumber: "+33612345678")
        phoneNumberTextField.setFormatted(phoneNumber: "+919979306224")

		view.addSubview(phoneNumberTextField)

		phoneNumberTextField.center = view.center
	}

	private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
		let toolbar: UIToolbar = UIToolbar()

		toolbar.barStyle = UIBarStyle.default
		toolbar.items = items
		toolbar.sizeToFit()

		return toolbar
	}

	@objc func dismissCountries() {
		listController.dismiss(animated: true, completion: nil)
	}
}

extension SimpleViewController: FPNTextFieldDelegate {

	func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
		textField.rightViewMode = .always
		textField.rightView = UIImageView(image: isValid ? #imageLiteral(resourceName: "success") : #imageLiteral(resourceName: "error"))

		print(
			isValid,
			textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
			textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
			textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
			textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
			textField.getRawPhoneNumber() ?? "Raw: nil"
		)
	}

	func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
		print(name, dialCode, code)
	}


	func fpnDisplayCountryList() {
		let navigationViewController = UINavigationController(rootViewController: listController)

		listController.title = "Countries"
		listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissCountries))

		self.present(navigationViewController, animated: true, completion: nil)
	}
}
