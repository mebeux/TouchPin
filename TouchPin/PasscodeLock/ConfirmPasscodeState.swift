//
//  ConfirmPasscodeState.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import Foundation

struct ConfirmPasscodeState: PasscodeLockStateType {
    
    let title: String
    let description: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
    
    private var passcodeToConfirm: [String]
    
    init(passcode: [String]) {
        
        passcodeToConfirm = passcode
		self.title =  PasscodeLockConfigurationStrings.sharedInstance.passcodeLockConfirmTitle!
		self.description = PasscodeLockConfigurationStrings.sharedInstance.passcodeLockConfirmDescription!
    }
	
    func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
        
        if passcode == passcodeToConfirm {
            
            lock.repository.savePasscode(passcode)
            lock.delegate?.passcodeLockDidSucceed(lock)
        
        } else {
            
            let mismatchTitle = PasscodeLockConfigurationStrings.sharedInstance.passcodeLockMismatchTitle
            let mismatchDescription = PasscodeLockConfigurationStrings.sharedInstance.passcodeLockMismatchDescription
            
            let nextState = SetPasscodeState(title: mismatchTitle!, description: mismatchDescription!)
            
            lock.changeStateTo(nextState)
            lock.delegate?.passcodeLockDidFail(lock)
        }
    }
}
