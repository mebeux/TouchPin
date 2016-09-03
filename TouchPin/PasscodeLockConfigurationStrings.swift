//
//  PasscodeLockConfigurationStrings.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 9/3/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import UIKit

class PasscodeLockConfigurationStrings: NSObject {
	
	static let sharedInstance = PasscodeLockConfigurationStrings()
	 var passcodeLockEnterTitle:String?
	 var passcodeLockEnterDescription:String?
	 var passcodeLockSetTitle:String?
	 var passcodeLockSetDescription:String?
	 var passcodeLockConfirmTitle:String?
	 var passcodeLockConfirmDescription:String?
	 var passcodeLockChangeTitle:String?
	 var passcodeLockChangeDescription:String?
	 var passcodeLockMismatchTitle:String?
	 var passcodeLockMismatchDescription:String?
	 var passcodeLockTouchIDReason:String?
	 var passcodeLockTouchIDButton:String?
	 var passcodeLockCancelButton:String?
	 var passcodeLockChangeButton:String?
	 var passcodeLockDeleteButton:String?

	func loadStrings(text: NSDictionary){
		self.passcodeLockEnterTitle = (text["passcodeLockEnterTitle"] as? String)
		self.passcodeLockEnterDescription = (text["passcodeLockEnterDescription"] as? String)
		self.passcodeLockSetTitle = (text["passcodeLockSetTitle"] as? String)
		self.passcodeLockSetDescription = (text["passcodeLockSetDescription"] as? String)
		self.passcodeLockConfirmTitle = (text["passcodeLockConfirmTitle"] as? String)
		self.passcodeLockConfirmDescription = (text["passcodeLockConfirmDescription"] as? String)
		self.passcodeLockChangeTitle = (text["passcodeLockChangeTitle"] as? String)
		self.passcodeLockChangeDescription = (text["passcodeLockChangeDescription"] as? String)
		self.passcodeLockMismatchTitle = (text["passcodeLockMismatchTitle"] as? String)
		self.passcodeLockMismatchDescription = (text["passcodeLockMismatchDescription"] as? String)
		self.passcodeLockTouchIDReason = (text["passcodeLockTouchIDReason"] as? String)
		self.passcodeLockTouchIDButton = (text["passcodeLockTouchIDButton"] as? String)
		self.passcodeLockCancelButton = (text["passcodeLockCancelButton"] as? String)
		self.passcodeLockChangeButton = (text["passcodeLockChangeButton"] as? String)
		self.passcodeLockDeleteButton = (text["passcodeLockDeleteButton"] as? String)
	}

}
