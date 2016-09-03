//
//  SetPasscodeState.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import Foundation

struct SetPasscodeState: PasscodeLockStateType {
    
    let title: String
    let description: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
    
    init(title: String, description: String) {
        
        self.title = title
        self.description = description
    }
    
	init() {
		
		self.title =  PasscodeLockConfigurationStrings.sharedInstance.passcodeLockSetTitle!
		self.description = PasscodeLockConfigurationStrings.sharedInstance.passcodeLockSetDescription!
	}
	
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        
        let nextState = ConfirmPasscodeState(passcode: passcode)
        
        lock.changeStateTo(nextState)
    }
}
