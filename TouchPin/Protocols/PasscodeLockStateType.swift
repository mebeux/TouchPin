//
//  PasscodeLockStateType.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import Foundation

public protocol PasscodeLockStateType {
    
    var title: String {get}
    var description: String {get}
    var isCancellableAction: Bool {get}
    var isTouchIDAllowed: Bool {get}
    
    mutating func acceptPasscode(passcode: [String], fromLock lock: PasscodeLockType)
}
