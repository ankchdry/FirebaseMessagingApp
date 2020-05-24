//
//  OCPasswordToggleVisibilityView.swift
//  oxfordCaps
//
//  Created by Ankit Chaudhary on 05/04/19.
//  Copyright © 2019 Ankit  Chaudhary. All rights reserved.
//

import UIKit

protocol PasswordToggleVisibilityDelegate: class {
    func viewWasToggled(passwordToggleVisibilityView: OCToggleVisibilityView, isSelected selected: Bool)
}

class OCToggleVisibilityView: UIView {
    private var eyeOpenedImage: UIImage!
    private var eyeClosedImage: UIImage!
    private var checkmarkImage: UIImage!
    private var stateButton: UIButton!
    private var checkmarkImageView: UIImageView!
    weak var delegate: PasswordToggleVisibilityDelegate?
    
    enum State {
        case Open
        case Closed
    }
    
    var eyeState: State! {
        set {
            stateButton.isSelected = newValue == .Open
        }
        get {
            return stateButton.isSelected ? .Open : .Closed
        }
    }
    
    var checkmarkVisible: Bool! {
        set {
            checkmarkImageView.isHidden = !newValue
        }
        get {
            return !checkmarkImageView.isHidden
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            stateButton.tintColor = UIColor.gray
            checkmarkImageView.tintColor = UIColor.gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, type: OCTextFieldType) {
        self.init(frame: frame)
        setupComponent(for: type)
        
        self.stateButton = UIButton(type: .custom)
        self.checkmarkImageView = UIImageView(image: self.checkmarkImage)
        self.setupViews()
    }
    
    func setupComponent(for type: OCTextFieldType) {
        switch type {
        case .date:
            self.eyeOpenedImage = UIImage(named: "EyeOpen")!.withRenderingMode(.alwaysTemplate)
            self.eyeClosedImage = UIImage(named: "EyeOpen")!
            self.checkmarkImage = UIImage(named: "EyeOpen")!.withRenderingMode(.alwaysTemplate)
            
        case .password:
            self.eyeOpenedImage = UIImage(named: "EyeOpen")!.withRenderingMode(.alwaysTemplate)
            self.eyeClosedImage = UIImage(named: "EyeOpen")!
            self.checkmarkImage = UIImage(named: "EyeOpen")!.withRenderingMode(.alwaysTemplate)
            
        default:
            ()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use init with coder.")
    }
    
    private func setupViews() {
        let padding: CGFloat = 11
        let buttonWidth = (frame.width / 2) - padding
        let buttonFrame = CGRect(x: buttonWidth + padding, y: 10, width: buttonWidth, height: buttonWidth)
        stateButton.frame = buttonFrame
        stateButton.backgroundColor = UIColor.clear
        stateButton.adjustsImageWhenHighlighted = false
        stateButton.setImage(self.eyeClosedImage, for: .normal)
        stateButton.setImage(self.eyeOpenedImage.withRenderingMode(.alwaysTemplate), for: .selected)
        stateButton.addTarget(self, action: #selector(stateButtonPressed), for: .touchUpInside)
        stateButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stateButton.tintColor = UIColor.gray
        self.addSubview(stateButton)
        
        let checkmarkImageWidth = (frame.width / 1.5) - padding
        let checkmarkFrame = CGRect(x: padding, y: 10, width: checkmarkImageWidth, height: frame.height)
        checkmarkImageView.frame = checkmarkFrame
        checkmarkImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        checkmarkImageView.contentMode = .center
        checkmarkImageView.backgroundColor = UIColor.clear
        self.checkmarkImageView.contentMode = .scaleToFill
        checkmarkImageView.tintColor = UIColor.gray
        self.addSubview(checkmarkImageView)
    }
    
    @objc func stateButtonPressed(sender: AnyObject) {
        stateButton.isSelected = !stateButton.isSelected
        if stateButton.isSelected == true {
            stateButton.tintColor = UIColor.primaryButton
        } else {
            stateButton.tintColor = UIColor.gray
        }
        delegate?.viewWasToggled(passwordToggleVisibilityView: self, isSelected: stateButton.isSelected)
    }
}

class OCPhoneView:UIView {
    
    var phonePrefixDetails: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        phonePrefixDetails = UILabel.init()
        phonePrefixDetails.attributedText = [UIImage.init(named: "EyeImage")!.getAttributedText(), "+91".getAttributedText()].combineAttributes()
        self.addSubview(phonePrefixDetails)
        phonePrefixDetails.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        phonePrefixDetails.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        phonePrefixDetails.sizeToFit()
    }
}

extension String {
    func getAttributedText(with attributes: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {
        let attText = NSAttributedString.init(string: self, attributes: attributes)
        return attText
    }
}

extension UIImage {
    func getAttributedText(with attributes: [NSAttributedString.Key: Any]? = nil, titleFont: UIFont?=nil
        ) -> NSAttributedString {
        let textAttachment = NSTextAttachment.init()
        textAttachment.image = self
        if let titleFont = titleFont {
            textAttachment.bounds = CGRect(x: 0, y: (titleFont.capHeight - textAttachment.image!.size.height).rounded() / 2, width: textAttachment.image!.size.width, height: textAttachment.image!.size.height)
        }
        let attributedText = NSAttributedString.init(attachment: textAttachment)
        return attributedText
    }
}

extension Array where Element : NSAttributedString {
    func combineAttributes() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString.init()
        for element in self {
            attributedString.append(element)
        }
        return attributedString
    }
}
