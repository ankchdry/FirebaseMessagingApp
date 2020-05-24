//
//  OCTextField.swift
//  oxfordCaps
//
//  Created by Ankit Chaudhary on 02/04/19.
//  Copyright © 2019 Ankit  Chaudhary. All rights reserved.
//

import UIKit

enum OCTextFieldType:Int, CaseIterable {
    case text = 20, password, date, phoneNumber, search
}

protocol HideShowPasswordTextFieldDelegate: class {
    func isValidPassword(password: String) -> Bool
}

/**
 An AkiraTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the edges of the control.
 */
@IBDesignable open class OCTextField : OCTextFieldEffects {
    
    private let borderSize: (active: CGFloat, inactive: CGFloat) = (0.5, 0.5)
    private let borderLayer = CALayer()
    private let textFieldInsets = CGPoint(x: 15, y: -8)
    private let placeholderInsets = CGPoint(x: 15, y: 0)
    var additionalLayer: CALayer!
    
    weak var passwordDelegate: HideShowPasswordTextFieldDelegate?
    var preferredFont = Font.book(size: 12, font: FontName.SharpSans).fetch()
    
    var textFieldType: OCTextFieldType = .password
    
    
    override open var isSecureTextEntry: Bool {
        didSet {
            if !isSecureTextEntry {
                self.font = Font.book(size: 12, font: FontName.SharpSans).fetch()
                self.font = Font.book(size: 12, font: FontName.SharpSans).fetch()
            }
        }
    }
    var passwordToggleVisibilityView: OCToggleVisibilityView!
    
    /**
     The color of the border.
     
     This property applies a color to the bounds of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    
    @IBInspectable var textFieldTypeBox: Int = 20 {
        didSet(nVal) {
            self.textFieldType = OCTextFieldType.init(rawValue: textFieldTypeBox)!
        }
    }
    
    /**
     The color of the placeholder text.
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.7 {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable dynamic open var cornerRadius: CGFloat = 12 {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updateBorder()
        }
    }
    
    // MARK: TextFieldEffects
    override open func drawViewsForRect(_ rect: CGRect) {
        updateBorder()
        updatePlaceholder()
        addSubview(placeholderLabel)
        layer.insertSublayer(borderLayer, at: 0)
        
        // Check whether code is running for interface builder or not.
        #if !TARGET_INTERFACE_BUILDER
        if self.textFieldType != .text {
            self.setupView(for: self.textFieldType)
        }
        if self.textFieldType == .password {
            self.isSecureTextEntry = true
        }
        #endif
    }
    
    override open func animateViewsForTextEntry() {
        UIView.animate(withDuration: 0.3, animations: {
            self.updateBorder()
            self.updatePlaceholder()
            self.updateTextEntryConstraint()
        }, completion: { _ in
            self.animationCompletionHandler?(.textEntry)
        })
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
    }
    
    override open func animateViewsForTextDisplay() {
        UIView.animate(withDuration: 0.3, animations: {
            self.updateBorder()
            self.updatePlaceholder()
            self.updateTextDisplayConstraint()
        }, completion: { _ in
            self.animationCompletionHandler?(.textDisplay)
        })
    }
    
    // MARK: Private
    
    private func updateTextEntryConstraint() {
        borderLayer.borderColor = UIColor.textFieldBorder.cgColor
        borderLayer.borderWidth = 1.0
        placeholderLabel.attributedText = NSAttributedString.init(string: placeholder?.uppercased() ?? "", attributes: [NSAttributedString.Key.font : Font.medium(size: 10, font: FontName.SharpSans).fetch(), NSAttributedString.Key.backgroundColor : UIColor.white, NSAttributedString.Key.foregroundColor : UIColor.headerTransparentColor])
    }
    
    private func updateTextDisplayConstraint() {
        borderLayer.borderColor = UIColor.textFieldBorder.cgColor
        borderLayer.borderWidth = 1.0
        placeholderLabel.attributedText = NSAttributedString.init(string: placeholder?.uppercased() ?? "", attributes: [NSAttributedString.Key.font : Font.book(size: 12, font: FontName.SharpSans).fetch(), NSAttributedString.Key.backgroundColor : UIColor.white, NSAttributedString.Key.foregroundColor : UIColor.headerTransparentColor])
    }
    
    private func updatePlaceholder() {
        placeholderLabel.frame = placeholderRect(forBounds: bounds)
        placeholderLabel.attributedText = NSAttributedString.init(string: placeholder?.uppercased() ?? "", attributes: [NSAttributedString.Key.font : Font.book(size: 12, font: FontName.SharpSans).fetch(), NSAttributedString.Key.backgroundColor : UIColor.white, NSAttributedString.Key.foregroundColor : UIColor.headerTransparentColor])
        placeholderLabel.font = placeholderFontFromFont(font!)
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
    }
    
    private func updateBorder() {
        borderLayer.frame = rectForBounds(bounds)
        borderLayer.borderColor = UIColor.textFieldBorder.cgColor
        borderLayer.borderWidth = (isFirstResponder || text!.isNotEmpty) ? borderSize.active : borderSize.inactive
        borderLayer.cornerRadius = cornerRadius
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize)
        return smallerFont
    }
    
    private var placeholderHeight : CGFloat {
        return placeholderInsets.y + placeholderFontFromFont(font!).lineHeight
    }
    
    private func rectForBounds(_ bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y - 15 + placeholderHeight, width: bounds.size.width, height: bounds.size.height - placeholderHeight + 15)
    }
    
    // MARK: - Overrides
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if isFirstResponder || text!.isNotEmpty {
            return CGRect(x: placeholderInsets.x + 10, y: placeholderInsets.y - 8, width: bounds.width, height: placeholderHeight)
        } else {
            return textRect(forBounds: bounds)
        }
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y + placeholderHeight/2)
    }
    
}

extension OCTextField: PasswordToggleVisibilityDelegate {
    func viewWasToggled(passwordToggleVisibilityView: OCToggleVisibilityView, isSelected selected: Bool) {
        
        // hack to fix a bug with padding when switching between isSecureTextEntry state
        let hackString = self.text
        self.text = " "
        self.text = hackString
        
        // hack to save our correct font.  The order here is VERY finicky
        self.isSecureTextEntry = !selected
    }
}

extension OCTextField {
    func setupView(for type: OCTextFieldType) {
        switch type {
        case .password:
            let toggleFrame = CGRect(x: 0, y: 10, width: 66, height: frame.height)
            passwordToggleVisibilityView = OCToggleVisibilityView(frame: toggleFrame, type: type)
            passwordToggleVisibilityView.delegate = self
            passwordToggleVisibilityView.checkmarkVisible = false
            
            self.keyboardType = .asciiCapable
            self.rightView = passwordToggleVisibilityView
            self.rightViewMode = .always
//            self.font = Font.medium(size: 14, font: FontName.SharpSans).fetch()
            self.textColor = UIColor.segmentedBarStrip
            self.addTarget(self, action: #selector(OCTextField.passwordTextChanged), for: .editingChanged)
            
            // if we don't do this, the eye flies in on textfield focus!
            self.rightView?.frame = self.rightViewRect(forBounds: self.bounds)
            
            // default eye state based on our initial secure text entry
            passwordToggleVisibilityView.eyeState = isSecureTextEntry ? .Closed : .Open
            
        case .phoneNumber:
            let leftFrame =  UIView.init(frame: CGRect(x: 0, y: 10, width: 85, height: frame.height))
            
            let flagImage = UIImageView.init(frame: CGRect.init(x: 16, y: 16, width: 24, height: 16))
            flagImage.image = UIImage.init(named: "flagImage")
            flagImage.contentMode = .scaleAspectFit
            
            let prefixLabel = UILabel.init(frame: CGRect.init(x: 58, y: 16, width: 22, height: 30))
            prefixLabel.text = "+91"
            prefixLabel.font = Font.bold(size: 12.0, font: FontName.SharpSans).fetch()
            prefixLabel.sizeToFit()
            
            leftFrame.addSubview(flagImage)
            leftFrame.addSubview(prefixLabel)
            
            self.keyboardType = .numberPad
            self.leftView = leftFrame
            self.leftViewMode = .unlessEditing
            self.font = Font.medium(size: 14, font: FontName.SharpSans).fetch()
            self.textColor = UIColor.segmentedBarStrip
            
            // if we don't do this, the eye flies in on textfield focus!
            self.leftView?.frame = self.leftViewRect(forBounds: self.bounds)
            
        case .date:
            let dateFrame = UIImageView.init(frame: CGRect(x: 0, y: 10, width: 36, height: 36))
            dateFrame.image = UIImage.init(named: "calendar")
            dateFrame.contentMode = .scaleAspectFit
            
            self.rightView = dateFrame
            self.rightViewMode = .always
            self.font = Font.medium(size: 14, font: FontName.SharpSans).fetch()
            self.textColor = UIColor.segmentedBarStrip
            
            // if we don't do this, the eye flies in on textfield focus!
            self.rightView?.frame = self.rightViewRect(forBounds: self.bounds)
            self.setNeedsLayout()
            
            
        case .search:
            let dateContainer = UIView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
            let dateFrame = UIImageView.init(frame: CGRect(x: 0, y: 5, width: 20, height: 36))
            dateFrame.image = UIImage.init(named: "search")
            dateFrame.contentMode = .scaleAspectFit
            dateContainer.addSubview(dateFrame)
            self.rightView = dateContainer
            self.rightViewMode = .always
            self.font = Font.medium(size: 14, font: FontName.SharpSans).fetch()
            self.textColor = UIColor.segmentedBarStrip
            
            // if we don't do this, the eye flies in on textfield focus!
            self.rightView?.frame = self.rightViewRect(forBounds: self.bounds)
            self.setNeedsLayout()
            
        default:
            ()
        }
        
    }
}

// MARK: Control events
extension OCTextField {
    @objc func passwordTextChanged(sender: AnyObject) {
        if let password = self.text {
            passwordToggleVisibilityView.checkmarkVisible = passwordDelegate?.isValidPassword(password: password) ?? false
        } else {
            passwordToggleVisibilityView.checkmarkVisible = false
        }
    }
    
    @objc func dateFieldEdited(sender: AnyObject) {
        print("Date field button pressed.")
    }
}
