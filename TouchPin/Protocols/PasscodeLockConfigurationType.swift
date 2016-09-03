//
//  PasscodeLockConfigurationType.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import Foundation

public protocol PasscodeLockConfigurationType  {
	
	var repository: PasscodeRepositoryType? {get}
	var passcodeLength: Int? {get}
	var isTouchIDAllowed: Bool? {get set}
	var shouldRequestTouchIDImmediately: Bool? {get}
	var maximumInccorectPasscodeAttempts: Int? {get}
	var resetWhenIncorrectPasscode: Bool? {get}
	var backgroundColor: UIColor? {get}
	var backgroundImage: UIImage? {get}
	var titleColor: UIColor? {get}
	var descriptionColor: UIColor? {get}
	var buttonColor: UIColor? {get}
	var buttonBorderColor: UIColor? {get}
	var buttonBackground: UIColor? {get}
	var buttonTextColor: UIColor? {get}
	var optionsColor: UIColor? {get}
	var numberColor: UIColor? {get}
	var inactiveCodeColor: UIColor? {get}
	var activeCodeColor: UIColor? {get}
	var errorCodeColor: UIColor? {get}
	
	
}
