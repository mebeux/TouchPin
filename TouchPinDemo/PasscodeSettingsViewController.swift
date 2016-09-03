//
//  PasscodeSettingsViewController.swift
//  PasscodeLockDemo
//
//  Created by Yanko Dimitrov on 8/29/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit
import TouchPin

class PasscodeSettingsViewController: UIViewController {
    
    @IBOutlet weak var passcodeSwitch: UISwitch!
    @IBOutlet weak var changePasscodeButton: UIButton!
    
	private var configuration:PasscodeLockConfiguration
    
	init(configuration: PasscodeLockConfiguration) {
		
		self.configuration = configuration
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		
		configuration = PasscodeLockConfiguration()
		
		super.init(coder: aDecoder)
	}
	
    // MARK: - View
	
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updatePasscodeView()
    }
    
    func updatePasscodeView() {
        
        let hasPasscode = self.configuration.hasPassCode()
		
        changePasscodeButton.hidden = !hasPasscode
        passcodeSwitch.on = hasPasscode
    }
    
    // MARK: - Actions
    
    @IBAction func passcodeSwitchValueChange(sender: UISwitch) {
        
        let passcodeVC: PasscodeLockViewController
        
        if passcodeSwitch.on {
            
			passcodeVC = PasscodeLockViewController(state: .SetPasscode, configuration: configuration, isCancel: false)
			
        } else {
            
            passcodeVC = PasscodeLockViewController(state: .RemovePasscode, configuration: configuration)
            
            passcodeVC.successCallback = { lock in
                
                lock.repository.deletePasscode()
            }
        }
        
        presentViewController(passcodeVC, animated: true, completion: nil)
    }
	
	@IBAction func changePasscodeButtonTap(sender: UIButton) {
		
		
		let config = PasscodeLockConfiguration()
		
		let passcodeLock = PasscodeLockViewController(state: .ChangePasscode, configuration: config)
		
		presentViewController(passcodeLock, animated: true, completion: nil)
	}
}
