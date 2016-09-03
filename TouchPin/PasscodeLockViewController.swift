//
//  PasscodeLockViewController.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import UIKit

protocol PasscodeLockViewControllerDelegate : class {
	func dissmissEnter()
	func addNew(newVC: PasscodeLockViewController)
}


public class PasscodeLockViewController: UIViewController, PasscodeLockTypeDelegate {
    
    public enum LockState {
        case EnterPasscode
        case SetPasscode
        case ChangePasscode
        case RemovePasscode
        
        func getState() -> PasscodeLockStateType {
            
            switch self {
            case .EnterPasscode: return EnterPasscodeState()
            case .SetPasscode: return SetPasscodeState()
            case .ChangePasscode: return ChangePasscodeState()
            case .RemovePasscode: return EnterPasscodeState(allowCancellation: true)
            }
        }
    }
	
	public let PasscodeLockIncorrectPasscodeNotification = "passcode.lock.incorrect.passcode.notification"
	public let PasscodeLockIncorrectPasscodeNotificationInternal = "passcode.lock.incorrect.passcode.notification.internal"
	public let PasscodeLockIncorrectLastChancePasscodeNotification = "passcode.lock.incorrect.last.passcode.notification"
	var passcodeLockViewControllerDelegate: PasscodeLockViewControllerDelegate?
	var isCanceledPress = false
	@IBOutlet public weak var backgroundImage: UIImageView?
	@IBOutlet public weak var backgroundView: UIView?
    @IBOutlet public weak var titleLabel: UILabel?
	@IBOutlet public weak var twoLabel: UILabel?
	@IBOutlet public weak var threeLabel: UILabel?
	@IBOutlet public weak var fourLabel: UILabel?
	@IBOutlet public weak var fiveLabel: UILabel?
	@IBOutlet public weak var sixLabel: UILabel?
	@IBOutlet public weak var sevenLabel: UILabel?
	@IBOutlet public weak var eightLabel: UILabel?
	@IBOutlet public weak var nineLabel: UILabel?
    @IBOutlet public weak var descriptionLabel: UILabel?
	@IBOutlet public weak var placeHolderConstraint: NSLayoutConstraint?
	@IBOutlet public weak var placeholder: PasscodeSignContent?
    @IBOutlet public weak var cancelButton: UIButton?
    @IBOutlet public weak var deleteSignButton: UIButton?
	@IBOutlet public weak var changeSignButton: UIButton?
    @IBOutlet public weak var touchIDButton: UIButton?
    @IBOutlet public weak var placeholdersX: NSLayoutConstraint?
	@IBOutlet public weak var centerY: NSLayoutConstraint?
	@IBOutlet public weak var centerTitleY: NSLayoutConstraint?
	@IBOutlet public weak var buttomSpaceLeft: NSLayoutConstraint?
	@IBOutlet public weak var buttomSpaceRight: NSLayoutConstraint?
    
    public var successCallback: ((lock: PasscodeLockType) -> Void)?
    public var dismissCompletionCallback: (()->Void)?
    public var animateOnDismiss: Bool
    public var notificationCenter: NSNotificationCenter?
    internal var placeholders: [PasscodeSignPlaceholderView] = [PasscodeSignPlaceholderView]()
	internal var state: LockState?
    internal let passcodeConfiguration: PasscodeLockConfigurationType
    internal var passcodeLock: PasscodeLockType
    internal var isPlaceholdersAnimationCompleted = true
    
    private var shouldTryToAuthenticateWithBiometrics = true
    
    // MARK: - Initializers
    
    public init(state: PasscodeLockStateType, configuration: PasscodeLockConfigurationType, animateOnDismiss: Bool = true) {
		        self.animateOnDismiss = animateOnDismiss
        passcodeConfiguration = configuration
        passcodeLock = PasscodeLock(state: state, configuration: configuration)
        
        let nibName = "PasscodeLockView"
        let bundle: NSBundle = bundleForResource(nibName, ofType: "nib")
        
        super.init(nibName: nibName, bundle: bundle)
		
        passcodeLock.delegate = self
        notificationCenter = NSNotificationCenter.defaultCenter()
    }
    
	public convenience init(state: LockState, configuration: PasscodeLockConfigurationType, animateOnDismiss: Bool = true, isCancel: Bool) {

        self.init(state: state.getState(), configuration: configuration, animateOnDismiss: animateOnDismiss)
		self.state = state
		
    }
	
	public convenience init(state: LockState, configuration: PasscodeLockConfigurationType, animateOnDismiss: Bool = true) {
		
		self.init(state: state.getState(), configuration: configuration, animateOnDismiss: animateOnDismiss)
		self.state = state
		
	}
	
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
       // clearEvents()
    }
    
    // MARK: - View
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        placeholders = placeholder!.arrPlaceHolder
        updatePasscodeView()
		self.isCancel()
		haveSign(false)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
		if(self.state == .EnterPasscode){
			notificationCenter?.addObserver(self, selector: #selector(PasscodeLockViewController.dismissMe), name: PasscodeLockIncorrectPasscodeNotificationInternal, object: nil)
		}
        if shouldTryToAuthenticateWithBiometrics {
        
            authenticateWithBiometrics()
        }

    }
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		setupEvents()
		setupCenter()
	}
	
	public override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(true)
		clearEvents()
	}

    
    internal func updatePasscodeView() {
		setupColors()
        titleLabel?.text = passcodeLock.state.title
        descriptionLabel?.text = passcodeLock.state.description
        touchIDButton?.hidden = !passcodeLock.isTouchIDAllowed
		haveSign(false)
    }
    
    // MARK: - Events
    
	private func setupEvents() {
		
		notificationCenter?.addObserver(self, selector: #selector(PasscodeLockViewController.appWillEnterForegroundHandler(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil)
		notificationCenter?.addObserver(self, selector: #selector(PasscodeLockViewController.appDidEnterBackgroundHandler(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
		notificationCenter?.addObserver(self, selector: #selector(PasscodeLockViewController.newCode), name: PasscodeLockIncorrectPasscodeNotification, object: nil)

	}
	
	@objc private func dismissMe(){
		dismissPasscodeLock(self.passcodeLock)
	}
	
	private func clearEvents() {
		
		notificationCenter?.removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
		notificationCenter?.removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
		notificationCenter?.removeObserver(self, name: PasscodeLockIncorrectPasscodeNotification, object: nil)
	}
	
	
    public func appWillEnterForegroundHandler(notification: NSNotification) {
        
        authenticateWithBiometrics()
    }
    
    public func appDidEnterBackgroundHandler(notification: NSNotification) {
        
        shouldTryToAuthenticateWithBiometrics = false
    }
    
    // MARK: - Actions
	
	@objc public func newCode(){
		
		let passcodeLock = PasscodeLockViewController(state: .SetPasscode, configuration: self.passcodeConfiguration, isCancel: false)
		self.passcodeLockViewControllerDelegate?.addNew(passcodeLock)
		presentViewController(passcodeLock, animated: true, completion: nil)
	}
    
    @IBAction func passcodeSignButtonTap(sender: PasscodeSignButton) {
        
        guard isPlaceholdersAnimationCompleted else { return }
        passcodeLock.addSign(sender.passcodeSign)
    }
    
    @IBAction func cancelButtonTap(sender: UIButton) {
        isCanceledPress = true
        dismissPasscodeLock(passcodeLock)
    }
	
	@IBAction func changeSignButtonTap(sender: UIButton) {
		
		let passcodeLock = PasscodeLockViewController(state: .ChangePasscode, configuration: self.passcodeConfiguration, isCancel: true)
		self.passcodeLockViewControllerDelegate?.addNew(passcodeLock)
		presentViewController(passcodeLock, animated: true, completion: nil)
	
	}
	
    @IBAction func deleteSignButtonTap(sender: UIButton) {
		
			passcodeLock.removeSign()

    }
    
    @IBAction func touchIDButtonTap(sender: UIButton) {
        
        passcodeLock.authenticateWithBiometrics()
    }
    
    private func authenticateWithBiometrics() {
        
        if passcodeConfiguration.shouldRequestTouchIDImmediately! && passcodeLock.isTouchIDAllowed {
            
            passcodeLock.authenticateWithBiometrics()
        }
    }
	
    internal func dismissPasscodeLock(lock: PasscodeLockType, completionHandler: (() -> Void)? = nil) {
		if(!isCanceledPress && state != .EnterPasscode){
			self.passcodeLockViewControllerDelegate?.dissmissEnter()
		}
        // if presented as modal
        if presentingViewController?.presentedViewController == self {
            
            dismissViewControllerAnimated(true, completion: { [weak self] _ in
                
                self?.dismissCompletionCallback?()
                
                completionHandler?()
            })

            return
            
        // if pushed in a navigation controller
        } else if navigationController != nil {
        
            navigationController?.popViewControllerAnimated(animateOnDismiss)
        }
		
        dismissCompletionCallback?()
        
        completionHandler?()
    }
    
    // MARK: - Animations
    
    internal func animateWrongPassword() {
		
        isPlaceholdersAnimationCompleted = false
        
        animatePlaceholders(placeholders, toState: .Error)
        
        placeholdersX?.constant = -40
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(
            0.5,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0,
            options: [],
            animations: {
				

                self.placeholdersX?.constant = 0
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                
                self.isPlaceholdersAnimationCompleted = true
                self.animatePlaceholders(self.placeholders, toState: .Inactive)
        })
    }
    
    internal func animatePlaceholders(placeholders: [PasscodeSignPlaceholderView], toState state: PasscodeSignPlaceholderView.State) {
        
        for placeholder in placeholders {
            
            placeholder.animateState(state)
        }
    }
    
    private func animatePlacehodlerAtIndex(index: Int, toState state: PasscodeSignPlaceholderView.State) {
        
        guard index < placeholders.count && index >= 0 else { return }
        
        placeholders[index].animateState(state)
    }

    // MARK: - PasscodeLockDelegate
    
    public func passcodeLockDidSucceed(lock: PasscodeLockType) {
		
        animatePlaceholders(placeholders, toState: .Inactive)
        dismissPasscodeLock(lock, completionHandler: { [weak self] _ in
            self?.successCallback?(lock: lock)
        })
    }
    
    public func passcodeLockDidFail(lock: PasscodeLockType) {
		haveSign(false)
        animateWrongPassword()
    }
    
    public func passcodeLockDidChangeState(lock: PasscodeLockType) {
        
        updatePasscodeView()
        animatePlaceholders(placeholders, toState: .Inactive)
		haveSign(false)
    }
    
    public func passcodeLock(lock: PasscodeLockType, addedSignAtIndex index: Int) {
        
        animatePlacehodlerAtIndex(index, toState: .Active)
        haveSign(true)

    }
    
    public func passcodeLock(lock: PasscodeLockType, removedSignAtIndex index: Int) {
        
        animatePlacehodlerAtIndex(index, toState: .Inactive)
        
        if index == 0 {
            
            haveSign(false)
        }
    }
	
	private func setupColors(){
		self.backgroundView?.backgroundColor = passcodeConfiguration.backgroundColor
		self.backgroundImage?.image = passcodeConfiguration.backgroundImage
		self.placeholder?.activeColor = passcodeConfiguration.activeCodeColor!
		self.placeholder?.inactiveColor = passcodeConfiguration.inactiveCodeColor!
		self.placeholder?.errorColor = passcodeConfiguration.errorCodeColor!
		self.titleLabel?.textColor = passcodeConfiguration.titleColor
		self.descriptionLabel?.textColor = passcodeConfiguration.descriptionColor
		self.cancelButton?.setTitleColor(passcodeConfiguration.optionsColor, forState: .Normal)
		self.deleteSignButton?.setTitleColor(passcodeConfiguration.optionsColor, forState: .Normal)
		self.changeSignButton?.setTitleColor(passcodeConfiguration.optionsColor, forState: .Normal)
		self.twoLabel?.textColor = passcodeConfiguration.buttonTextColor
		self.threeLabel?.textColor = passcodeConfiguration.buttonTextColor
		self.fourLabel?.textColor = passcodeConfiguration.buttonTextColor
		self.fiveLabel?.textColor = passcodeConfiguration.buttonTextColor
		self.sixLabel?.textColor = passcodeConfiguration.buttonTextColor
		self.sevenLabel?.textColor = passcodeConfiguration.buttonTextColor
		self.eightLabel?.textColor = passcodeConfiguration.buttonTextColor
		self.nineLabel?.textColor = passcodeConfiguration.buttonTextColor
		for SignButton in self.view.subviews {
			if let sButton = SignButton as? PasscodeSignButton{
				sButton.borderColor  = passcodeConfiguration.buttonBorderColor!
				
				sButton.backgroundColor = passcodeConfiguration.buttonBackground
				sButton.highlightBackgroundColor = passcodeConfiguration.buttonColor!
				sButton.setTitleColor(passcodeConfiguration.buttonTextColor, forState: .Normal)
				sButton.setTitleColor(passcodeConfiguration.buttonTextColor, forState: .Selected)
				sButton.setTitleColor(passcodeConfiguration.buttonTextColor, forState: .Highlighted)
			}
		}
		self.cancelButton?.setTitle(PasscodeLockConfigurationStrings.sharedInstance.passcodeLockCancelButton, forState: .Normal)
		self.cancelButton?.setTitle(PasscodeLockConfigurationStrings.sharedInstance.passcodeLockCancelButton, forState: .Selected)
		self.cancelButton?.setTitle(PasscodeLockConfigurationStrings.sharedInstance.passcodeLockCancelButton, forState: .Highlighted)
		self.deleteSignButton?.setTitle(PasscodeLockConfigurationStrings.sharedInstance.passcodeLockDeleteButton, forState: .Normal)
		self.deleteSignButton?.setTitle(PasscodeLockConfigurationStrings.sharedInstance.passcodeLockDeleteButton, forState: .Selected)
		self.deleteSignButton?.setTitle(PasscodeLockConfigurationStrings.sharedInstance.passcodeLockDeleteButton, forState: .Highlighted)
		self.changeSignButton?.setTitle(PasscodeLockConfigurationStrings.sharedInstance.passcodeLockChangeButton, forState: .Normal)
		self.changeSignButton?.setTitle(PasscodeLockConfigurationStrings.sharedInstance.passcodeLockChangeButton, forState: .Selected)
		self.changeSignButton?.setTitle(PasscodeLockConfigurationStrings.sharedInstance.passcodeLockChangeButton, forState: .Highlighted)
		
	}
	
	
	
	private func isCancel(){
		if(self.state! != .EnterPasscode && self.state! != .SetPasscode){
				self.enableBtn(cancelButton!, enable: true)
		}else{
			self.enableBtn(cancelButton!, enable: false)
		}
	}
	
	private func haveSign(have: Bool){
		if(have){
			self.enableBtn(deleteSignButton!, enable: true)
			self.enableBtn(changeSignButton!, enable: false)
		}else if(!have && !canChange()){
			self.enableBtn(deleteSignButton!, enable: false)
			self.enableBtn(changeSignButton!, enable: false)
		}else if(!have && canChange()){
			self.enableBtn(deleteSignButton!, enable: false)
			self.enableBtn(changeSignButton!, enable: true)
		}
	}
	
	private func enableBtn(btn: UIButton, enable: Bool){
			btn.hidden = !enable
			btn.enabled = enable
	}

	private func canChange()->Bool{
		if(self.state! == .EnterPasscode){
			return true
		}else{
			return false
		}
	}
	
	private func setupCenter(){
		if(UIScreen.mainScreen().bounds.height  < 568){
			self.centerY?.constant = 18
			self.centerTitleY?.constant = -30
			self.buttomSpaceLeft?.constant = 20
			self.buttomSpaceRight?.constant = 20
		}
	}
	
}
