//
//  FlagPhoneNumberTextFieldDelegate.swift
//  FlagPhoneNumber
//
//  Created by Aurélien Grifasi on 06/08/2017.
//  Copyright (c) 2017 Aurélien Grifasi. All rights reserved.
//

import UIKit

@objc
public protocol FPNTextFieldDelegate: class, UITextFieldDelegate {
	@objc optional func fpnDidSelectCountry(name: String, dialCode: String, code: String)
    @objc optional func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool)
    @objc optional func fpnDisplayCountryList()
}
