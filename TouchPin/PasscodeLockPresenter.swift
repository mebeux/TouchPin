//
//  PasscodeLockPresenter.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import UIKit

public class PasscodeLockPresenter: PasscodeLockViewControllerDelegate {
    
    private var mainWindow: UIWindow?
	
	private var controllersList:[PasscodeLockViewController] = [PasscodeLockViewController]()
    
    private lazy var passcodeLockWindow: UIWindow = {
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window.windowLevel = 0
        window.makeKeyAndVisible()
        
        return window
    }()
    
    private let passcodeConfiguration: PasscodeLockConfigurationType
    public var isPasscodePresented = false
    public let passcodeLockVC: PasscodeLockViewController
	
    public init(mainWindow window: UIWindow?, configuration: PasscodeLockConfigurationType, viewController: PasscodeLockViewController) {
        
        mainWindow = window
        mainWindow?.windowLevel = 1
        passcodeConfiguration = configuration
        passcodeLockVC = viewController
		passcodeLockVC.passcodeLockViewControllerDelegate = self
		
    }

    public convenience init(mainWindow window: UIWindow?, configuration: PasscodeLockConfigurationType) {
        let passcodeLockVC = PasscodeLockViewController(state: .EnterPasscode, configuration: configuration)
        
        self.init(mainWindow: window, configuration: configuration, viewController: passcodeLockVC)
    }
	
	func addNew(newVC: PasscodeLockViewController){
		newVC.passcodeLockViewControllerDelegate = self
	}
	
	public func presentEnterPasscodeLock() {
		
		guard passcodeConfiguration.repository!.hasPasscode else {
			self.presentSetPasscodeLock()
			return
		}
		
		isPasscodePresented = true
		
		passcodeLockWindow.windowLevel = 2
		passcodeLockWindow.hidden = false
		
		mainWindow?.windowLevel = 1
		mainWindow?.endEditing(true)
		
		let passcodeLockVC = PasscodeLockViewController(state: .EnterPasscode, configuration: passcodeConfiguration)
		passcodeLockVC.passcodeLockViewControllerDelegate = self
		let userDismissCompletionCallback:(()->Void)? =  passcodeLockVC.dismissCompletionCallback
		
		passcodeLockVC.dismissCompletionCallback = { [weak self] in
			
			userDismissCompletionCallback?()
			
			self?.dismissPasscodeLock()
		}
		
		passcodeLockWindow.rootViewController = passcodeLockVC
	}
	

    public func presentPasscodeLock() {
		
        guard passcodeConfiguration.repository!.hasPasscode else {
			self.presentSetPasscodeLock()
			return
		}
        guard !isPasscodePresented else { return }
        
        isPasscodePresented = true
        
        passcodeLockWindow.windowLevel = 2
        passcodeLockWindow.hidden = false
        
        mainWindow?.windowLevel = 1
        mainWindow?.endEditing(true)
        
        let passcodeLockVC = PasscodeLockViewController(state: .EnterPasscode, configuration: passcodeConfiguration)
		passcodeLockVC.passcodeLockViewControllerDelegate = self
		let userDismissCompletionCallback:(()->Void)? =  passcodeLockVC.dismissCompletionCallback
        
        passcodeLockVC.dismissCompletionCallback = { [weak self] in
            
            userDismissCompletionCallback?()
            
            self?.dismissPasscodeLock()
        }
        
        passcodeLockWindow.rootViewController = passcodeLockVC
    }
	
	internal func dissmissEnter(){
		self.dismissPasscodeLock(animated: false)
	}
	
	private func presentSetPasscodeLock() {
		
		guard !passcodeConfiguration.repository!.hasPasscode else { return }
		
		isPasscodePresented = true
		
		passcodeLockWindow.windowLevel = 2
		passcodeLockWindow.hidden = false
		
		mainWindow?.windowLevel = 1
		mainWindow?.endEditing(true)
		
		let passcodeLockVC = PasscodeLockViewController(state: .SetPasscode, configuration: passcodeConfiguration)
		let userDismissCompletionCallback:(()->Void)? =  passcodeLockVC.dismissCompletionCallback
		passcodeLockVC.passcodeLockViewControllerDelegate = self
		passcodeLockVC.dismissCompletionCallback = { [weak self] in
			
			userDismissCompletionCallback?()
			
			self?.dismissPasscodeLock()
		}
		
		passcodeLockWindow.rootViewController = passcodeLockVC
	}
	
    public func dismissPasscodeLock(animated animated: Bool = true) {
		
        isPasscodePresented = false
        mainWindow?.windowLevel = 1
        mainWindow?.makeKeyAndVisible()
        
        if animated {
        
            animatePasscodeLockDismissal()
            
        } else {
            
            passcodeLockWindow.windowLevel = 0
            passcodeLockWindow.rootViewController = nil
        }
    }
    
    internal func animatePasscodeLockDismissal() {
        
        UIView.animateWithDuration(
            0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [.CurveEaseInOut],
            animations: { [weak self] in
                
                self?.passcodeLockWindow.alpha = 0
            },
            completion: { [weak self] _ in
                
                self?.passcodeLockWindow.windowLevel = 0
                self?.passcodeLockWindow.rootViewController = nil
                self?.passcodeLockWindow.alpha = 1
            }
        )
    }
}
