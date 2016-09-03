//
//  PasscodeSignContent.swift
//  TouchPin
//
//  Created by Maximo Ernesto Beux Sepulveda on 8/28/16.
//  Copyright © 2016 mebapps. All rights reserved.
//


import UIKit

@IBDesignable
public class PasscodeSignContent: UIView {
	
	let arrPlaceHolder = [PasscodeSignPlaceholderView(frame: CGRect(x: 0,y: 0, width: 16, height: 16)),
	                      PasscodeSignPlaceholderView(frame: CGRect(x: 40,y: 0, width: 16, height: 16)),
	                      PasscodeSignPlaceholderView(frame: CGRect(x: 80,y: 0, width: 16, height: 16)),
	                      PasscodeSignPlaceholderView(frame: CGRect(x: 120,y: 0, width: 16, height: 16)),
	                      PasscodeSignPlaceholderView(frame: CGRect(x: 160,y: 0, width: 16, height: 16)),
	                      PasscodeSignPlaceholderView(frame: CGRect(x: 200,y: 0, width: 16, height: 16))]
	
	public enum State {
		case Inactive
		case Active
		case Error
	}
	
	@IBInspectable
	public var inactiveColor: UIColor = UIColor.whiteColor() {
		didSet {
			setupPlaceHolder()
		}
	}
	
	@IBInspectable
	public var activeColor: UIColor = UIColor.grayColor() {
		didSet {
			setupPlaceHolder()
		}
	}
	
	@IBInspectable
	public var errorColor: UIColor = UIColor.redColor() {
		didSet {
			setupPlaceHolder()
		}
	}

	
	@IBInspectable
	public var countCode: Int = 4 {
		didSet {
			setupView()
		}
	}
	
	public override func intrinsicContentSize() -> CGSize {
		
		if(countCode == 4){
			return CGSizeMake(136, 16)
		}else{
			return CGSizeMake(216, 16)
		}
	}
	
	public override init(frame: CGRect) {
		
		super.init(frame: frame)
		
		setupView()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		
		super.init(coder: aDecoder)
	}
	
	private func setupPlaceHolder(){
		
		for  i in 0...arrPlaceHolder.count - 1 {
			arrPlaceHolder[i].inactiveColor = inactiveColor
			arrPlaceHolder[i].activeColor = activeColor
			arrPlaceHolder[i].errorColor = errorColor
		}
	}
	private func removeAllSubViews(){
		for view in self.subviews {
			view.removeFromSuperview()
		}
	}
	
	private func setupView() {
		if(countCode == 4){
			self.removeAllSubViews()
			layer.frame.size = CGSizeMake(136, 16.0)
			self.addSubview(arrPlaceHolder[0])
			self.addSubview(arrPlaceHolder[1])
			self.addSubview(arrPlaceHolder[2])
			self.addSubview(arrPlaceHolder[3])
		}else{
			self.removeAllSubViews()
			layer.frame.size = CGSizeMake(216, 16.0)
			self.addSubview(arrPlaceHolder[0])
			self.addSubview(arrPlaceHolder[1])
			self.addSubview(arrPlaceHolder[2])
			self.addSubview(arrPlaceHolder[3])
			self.addSubview(arrPlaceHolder[4])
			self.addSubview(arrPlaceHolder[5])
		}
	}
	
}

