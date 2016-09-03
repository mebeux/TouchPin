//
//  PasscodeLockConfiguration.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/29/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation
import TouchPin

struct PasscodeLockConfiguration: PasscodeLockConfigurationType {
	
    var repository: PasscodeRepositoryType
    var passcodeLength = 4
    var isTouchIDAllowed = true
    var shouldRequestTouchIDImmediately = true
    var maximumInccorectPasscodeAttempts = 2
	var resetWhenIncorrectPasscode = true
	var backgroundColor = UIColor.whiteColor()
	var titleColor = UIColor.blackColor()
	var descriptionColor = UIColor.grayColor()
	var buttonColor = UIColor.grayColor()
	var buttonTextColor = UIColor.blackColor()
	var optionsColor = UIColor.blackColor()
	var numberColor = UIColor.blackColor()
	var inactiveCodeColor = UIColor.whiteColor()
	var activeCodeColor = UIColor.grayColor()
	var errorCodeColor = UIColor.grayColor()
	
	init() {
		
		self.repository = UserDefaultsPasscodeRepository()
		var myDict: NSDictionary?
		if let path = NSBundle.mainBundle().pathForResource("TouchPinConfiguration", ofType: "plist") {
			myDict = NSDictionary(contentsOfFile: path)
		}
		if let dict = myDict {
			self.passcodeLength = (dict["passcodeLength"] as? Int)!
			self.isTouchIDAllowed = (dict["isTouchIDAllowed"] as? Bool)!
			self.shouldRequestTouchIDImmediately = (dict["shouldRequestTouchIDImmediately"] as? Bool)!
			self.maximumInccorectPasscodeAttempts = (dict["maximumInccorectPasscodeAttempts"] as? Int)!
			self.resetWhenIncorrectPasscode = (dict["resetWhenIncorrectPasscode"] as? Bool)!
			self.backgroundColor = UIColor(hex: (dict["backgroundColor"] as? String)!)
			self.titleColor = UIColor(hex: (dict["titleColor"] as? String)!)
			self.descriptionColor = UIColor(hex: (dict["descriptionColor"] as? String)!)
			self.buttonColor = UIColor(hex: (dict["buttonColor"] as? String)!)
			self.buttonTextColor = UIColor(hex: (dict["buttonTextColor"] as? String)!)
			self.optionsColor = UIColor(hex: (dict["optionsColor"] as? String)!)
			self.numberColor = UIColor(hex: (dict["numberColor"] as? String)!)
			self.inactiveCodeColor = UIColor(hex: (dict["inactiveCodeColor"] as? String)!)
			self.activeCodeColor = UIColor(hex: (dict["activeCodeColor"] as? String)!)
			self.errorCodeColor = UIColor(hex: (dict["errorCodeColor"] as? String)!)
		}
	}
 
}
