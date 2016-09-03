//
//  PasscodeSignButton.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//

import UIKit

@IBDesignable
public class PasscodeSignButton: UIButton {
    
    @IBInspectable
    public var passcodeSign: String = "1"
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.whiteColor() {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    public var borderRadius: CGFloat = 30 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    public var highlightBackgroundColor: UIColor = UIColor.clearColor() {
        didSet {
            setupView()
        }
    }
	
	@IBInspectable
	public var size: CGFloat = 60 {
		didSet {
			setupView()
		}
	}
	
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupView()
        setupActions()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupActions()
    }
	
	
    
    public override func intrinsicContentSize() -> CGSize {
		if(UIScreen.mainScreen().bounds.height >= 736){
			return CGSizeMake(82, 82)
		}else{
			return CGSizeMake(74, 74)
		}
    }
	
    private var defaultBackgroundColor = UIColor.clearColor()
    
    private func setupView() {
        layer.frame.size =  CGSizeMake(size, size)
        layer.borderWidth = 2
        layer.cornerRadius = borderRadius
        layer.borderColor = borderColor.CGColor
        updateBorderRadiusToPlus()
        if let backgroundColor = backgroundColor {
            
            defaultBackgroundColor = backgroundColor
        }
    }
    
    private func setupActions() {
        
        addTarget(self, action: #selector(PasscodeSignButton.handleTouchDown), forControlEvents: .TouchDown)
        addTarget(self, action: #selector(PasscodeSignButton.handleTouchUp), forControlEvents: [.TouchUpInside, .TouchDragOutside, .TouchCancel])
    }
    
    func handleTouchDown() {
        
        animateBackgroundColor(highlightBackgroundColor)
    }
    
    func handleTouchUp() {
        
        animateBackgroundColor(defaultBackgroundColor)
    }
    
    private func animateBackgroundColor(color: UIColor) {
        
        UIView.animateWithDuration(
            0.3,
            delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.0,
            options: [.AllowUserInteraction, .BeginFromCurrentState],
            animations: {
                
                self.backgroundColor = color
            },
            completion: nil
        )
    }
	
	private func updateBorderRadiusToPlus(){
		if(UIScreen.mainScreen().bounds.height >= 736){
			layer.cornerRadius = 41
			layer.frame.size =  CGSizeMake(82, 82)
		}else {
			layer.cornerRadius = 37
			layer.frame.size =  CGSizeMake(74, 74)
		}
	}
}
