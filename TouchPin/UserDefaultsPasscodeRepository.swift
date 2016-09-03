//
//  UserDefaultsPasscodeRepository.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import Foundation

public class UserDefaultsPasscodeRepository: PasscodeRepositoryType {
    
	private let passcodeKey:String
    
    private lazy var defaults: NSUserDefaults = {
        
        return NSUserDefaults.standardUserDefaults()
    }()
    
    public var hasPasscode: Bool {
        
        if passcode != nil {
            return true
        }
        
        return false
    }
    
    public var passcode: [String]? {
        
        return defaults.valueForKey(passcodeKey) as? [String] ?? nil
    }
    
    public func savePasscode(passcode: [String]) {
        
        defaults.setObject(passcode, forKey: passcodeKey)
        defaults.synchronize()
    }
    
    public func deletePasscode() {
        
        defaults.removeObjectForKey(passcodeKey)
        defaults.synchronize()
    }
	
	public init(){
		passcodeKey = "TouchPin.lock.mbs"
	}
	
}
