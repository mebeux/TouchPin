//
//  PasscodeLockConfiguration.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/29/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct PasscodeLockConfiguration: PasscodeLockConfigurationType {
	
	public var repository: PasscodeRepositoryType?
	public var passcodeLength:Int?
    public var isTouchIDAllowed:Bool?
    public var shouldRequestTouchIDImmediately:Bool?
    public var maximumInccorectPasscodeAttempts:Int?
	public var resetWhenIncorrectPasscode:Bool?
	public var backgroundColor:UIColor?
	public var backgroundImage:UIImage?
	public var titleColor:UIColor?
	public var descriptionColor:UIColor?
	public var buttonColor:UIColor?
	public var buttonBorderColor:UIColor?
	public var buttonBackground: UIColor?
	public var buttonTextColor:UIColor?
	public var optionsColor:UIColor?
	public var numberColor:UIColor?
	public var inactiveCodeColor:UIColor?
	public var activeCodeColor:UIColor?
	public var errorCodeColor:UIColor?

	
	public init() {
		self.repository = UserDefaultsPasscodeRepository()
		var myDict: NSDictionary?
		if let path = NSBundle.mainBundle().pathForResource("TouchPinConfiguration", ofType: "plist") {
			myDict = NSDictionary(contentsOfFile: path)

			if let dict = myDict {
				if let configuration = dict["passcodeConfiguration"] as? NSDictionary{
					self.passcodeLength = (configuration["passcodeLength"] as? Int)!
					self.isTouchIDAllowed = (configuration["isTouchIDAllowed"] as? Bool)!
					self.shouldRequestTouchIDImmediately = (configuration["shouldRequestTouchIDImmediately"] as? Bool)!
					self.maximumInccorectPasscodeAttempts = (configuration["maximumInccorectPasscodeAttempts"] as? Int)!
					self.resetWhenIncorrectPasscode = (configuration["resetWhenIncorrectPasscode"] as? Bool)!
				}
				if let style = dict["passcodeStyle"] as? NSDictionary{
					self.backgroundColor = UIColor(hexAlpha: (style["backgroundColor"] as? String)!)
					self.titleColor = UIColor(hexAlpha: (style["titleColor"] as? String)!)
					self.descriptionColor = UIColor(hexAlpha: (style["descriptionColor"] as? String)!)
					self.buttonColor = UIColor(hexAlpha: (style["buttonColor"] as? String)!)
					self.buttonBorderColor = UIColor(hexAlpha: (style["buttonBorderColor"] as? String)!)
					self.buttonBackground = UIColor(hexAlpha: (style["buttonBackgroundColor"] as? String)!)
					self.buttonTextColor = UIColor(hexAlpha: (style["buttonTextColor"] as? String)!)
					self.optionsColor = UIColor(hexAlpha: (style["optionsColor"] as?	String)!)
					self.numberColor = UIColor(hexAlpha: (style["numberColor"] as? String)!)
					self.inactiveCodeColor = UIColor(hexAlpha: (style["inactiveCodeColor"] as? String)!)
					self.activeCodeColor = UIColor(hexAlpha: (style["activeCodeColor"]	as? String)!)
					self.errorCodeColor = UIColor(hexAlpha: (style["errorCodeColor"] as? String)!)
					let image = (style["backgroundImage"] as? String)!
					if(image != ""){
						self.backgroundImage = UIImage(named: (style["backgroundImage"] as? String)!)
					}
				}
				if let text = dict["passcodeText"] as? NSDictionary{
					PasscodeLockConfigurationStrings.sharedInstance.loadStrings(text)
				}
			
				
			}
		}
		
	}
	
	public func hasPassCode()->Bool{
		return self.repository!.hasPasscode
	}
 
}
