//
//  ChangePasscodeState.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import Foundation

struct ChangePasscodeState: PasscodeLockStateType {
    
    let title: String
    let description: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
	
	private var inccorectPasscodeAttempts = 0
	private var isNotificationSent = false
	
	init() {
        
		self.title =  PasscodeLockConfigurationStrings.sharedInstance.passcodeLockChangeTitle!
		self.description = PasscodeLockConfigurationStrings.sharedInstance.passcodeLockChangeDescription!
    }
    
	mutating func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType) {
		
		guard let currentPasscode = lock.repository.passcode else {
			return
		}
		
		if passcode == currentPasscode {
			
			lock.delegate?.passcodeLockDidSucceed(lock)
			
		} else {
			
			inccorectPasscodeAttempts += 1
			if (inccorectPasscodeAttempts == lock.configuration.maximumInccorectPasscodeAttempts! - 1) {
				postNotificationLastChance()
			}
			
			if inccorectPasscodeAttempts >= lock.configuration.maximumInccorectPasscodeAttempts {
				postNotificationIncorrectInternal()
				if (lock.configuration.resetWhenIncorrectPasscode!) {
					lock.configuration.repository!.deletePasscode()
					isNotificationSent = false
				}
				postNotification()
				inccorectPasscodeAttempts = 0
			}
			
			lock.delegate?.passcodeLockDidFail(lock)
		}
	}
	
	private mutating func postNotificationIncorrectInternal() {
		
		//self.enterPasCodeStateDel?.dissmisMe()
		
		guard !isNotificationSent else { return }
		
		let center = NSNotificationCenter.defaultCenter()
		
		center.postNotificationName(PasscodeLockIncorrectPasscodeNotificationInternal, object: nil)
		
		isNotificationSent = true
	}
	
	private mutating func postNotificationLastChance() {
		
		guard !isNotificationSent else { return }
		
		let center = NSNotificationCenter.defaultCenter()
		
		center.postNotificationName(PasscodeLockIncorrectLastChancePasscodeNotification, object: nil)
		
		isNotificationSent = true
	}
	
	private mutating func postNotification() {
		
		guard !isNotificationSent else { return }
		
		let center = NSNotificationCenter.defaultCenter()
		
		center.postNotificationName(PasscodeLockIncorrectPasscodeNotification, object: nil)
		
		isNotificationSent = true
	}
}
