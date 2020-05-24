//
//  OCButton.swift
//  oxfordCaps
//
//  Created by Ankit Chaudhary on 02/04/19.
//  Copyright © 2019 Ankit  Chaudhary. All rights reserved.
//

import UIKit

enum OCButtonType:Int {
    case border = 1, round, primary, text
    
    func fetchStyle() -> (backgroundColor: UIColor, attributes: [NSAttributedString.Key : Any], boderWidth: Int) {
        switch self {
        case .border:
            return (UIColor.white, [NSAttributedString.Key.font : Font.bold(size: 12, font: FontName.SharpSans).fetch(), NSAttributedString.Key.foregroundColor : UIColor.primaryButton], 2)
        case .round:
            return (UIColor.primaryButton, [NSAttributedString.Key.font : Font.bold(size: 12, font: FontName.SharpSans).fetch(), NSAttributedString.Key.foregroundColor : UIColor.white], 2)
        case .primary:
            return (UIColor.primaryButton, [NSAttributedString.Key.font : Font.bold(size: 12, font: FontName.SharpSans).fetch(), NSAttributedString.Key.foregroundColor : UIColor.white], 0)
        case .text:
            return (UIColor.clear, [NSAttributedString.Key.font : Font.bold(size: 12, font: FontName.SharpSans).fetch(), NSAttributedString.Key.foregroundColor : UIColor.primaryButton], 0)
        }
    }
}

@IBDesignable class OCButton: UIButton {
    
    @IBInspectable var type: Int {
        get {
            return self.buttonShape.rawValue
        }
        
        set(shapeType) {
            self.buttonShape = OCButtonType.init(rawValue: shapeType) ?? OCButtonType.text
            self.configureButton()
        }
    }
    
    var buttonShape: OCButtonType = .text
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureButton()
    }
    
    func configureButton() {
        let buttonStyle = self.buttonShape.fetchStyle()
        self.setAttributedTitle(NSAttributedString.init(string: self.currentTitle ?? "", attributes: buttonStyle.attributes), for: .normal)
        self.backgroundColor = buttonStyle.backgroundColor
        if buttonStyle.boderWidth == 0 {
            self.layer.borderColor = UIColor.clear.cgColor
        } else {
            self.layer.cornerRadius = 24
            self.layer.borderColor = UIColor.primaryButton.cgColor
            self.layer.borderWidth = CGFloat.init(buttonStyle.boderWidth)
        }
    }
}
