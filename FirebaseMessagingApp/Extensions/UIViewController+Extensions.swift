//
//  UIViewController+Extensions.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func setStatusBarBackgroundColor(color: UIColor) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = color
        }
    }
    
    func setNavigationTitle(to str: String) {
        let navTitle = UILabel.init()
        navTitle.attributedText = NSAttributedString.init(string: str, attributes: [NSAttributedString.Key.font : Font.bold(size: 14, font: FontName.SharpSans).fetch(), NSAttributedString.Key.kern: 0.2])
        navTitle.sizeToFit()
        self.navigationItem.titleView = navTitle
    }
}
