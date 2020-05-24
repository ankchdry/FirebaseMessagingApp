//
//  UIColor+Extensions.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    static var steelGrey:UIColor {
        return UIColor(red: 126.0 / 255.0, green: 128.0 / 255.0, blue: 131.0 / 255.0, alpha: 1.0)
    }
    
    static var backgroundColor: UIColor {
        return UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    }
    
    // Tabbar colors.
    static var tabbarBarTintColor: UIColor {
        return UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    }
    
    static var backgroundDarkGrey: UIColor {
        return UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
    }
    
    static var tabItemSelected: UIColor {
        return UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
    }
    
    static var tabItemUnSelected : UIColor {
        return UIColor(red:0.27, green:0.27, blue:0.27, alpha:0.5)
    }
    
    // Navigation bar colors.
    static var navbarTintColor: UIColor {
        return UIColor(red:1.00, green:0.87, blue:0.00, alpha:1.0)
    }
    
    static var navbarTitleColor: UIColor {
        return UIColor(red:0.28, green:0.24, blue:0.07, alpha:1.0)
    }
    
    // Button colors
    static var primaryButton: UIColor {
        return UIColor(red:0.01, green:0.49, blue:0.54, alpha:1.0)
    }
    
    // Textfield Colors
    static var textFieldBorder: UIColor {
        return UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
    }
    
    static var headerTransparentColor: UIColor {
        return UIColor(red:0.24, green:0.24, blue:0.20, alpha:1.0)
    }
    
    // Segmented Strip
    static var segmentedBarStrip: UIColor {
        return UIColor(red:0.24, green:0.24, blue:0.20, alpha:1.0)
    }
    
    static var segmentedBarIndicator: UIColor {
        return UIColor(red:1.00, green:0.51, blue:0.38, alpha:1.0)
    }
    
    static var primaryTeak: UIColor {
        return UIColor(red:0.01, green:0.49, blue:0.54, alpha:1.0)
    }
    
    static var darkPeach: UIColor {
        return UIColor(red:0.93, green:0.45, blue:0.32, alpha:1.0)
    }
    
    static var fadedGreen: UIColor {
        return UIColor(red:0.47, green:0.76, blue:0.40, alpha:1.0)
    }
    
    // In progress request
    static var inProgressStatus: UIColor {
        return UIColor(red:0.01, green:0.49, blue:0.54, alpha:1.0)
    }
    
    static var cancelledStatus: UIColor {
        return UIColor(red:0.88, green:0.35, blue:0.35, alpha:1.0)
    }
    
    static var openStatus: UIColor {
        return UIColor(red:0.93, green:0.45, blue:0.32, alpha:1.0)
    }
    
    static var completedStatus: UIColor {
        return UIColor(red:0.47, green:0.76, blue:0.40, alpha:1.0)
    }
    
    static var greyishBrown: UIColor {
        return UIColor(red:0.24, green:0.24, blue:0.20, alpha:1.0)
    }
    
    static var brightRed: UIColor {
        return UIColor(red:0.87, green:0.00, blue:0.06, alpha:1.0)
    }
    
    static var ocean: UIColor {
        return UIColor(red:0.01, green:0.49, blue:0.54, alpha:1.0)
    }
}


extension UIColor {
    public convenience init?(hexadecimal: String) {
        let r, g, b, a: CGFloat

        if hexadecimal.hasPrefix("#") {
            let start = hexadecimal.index(hexadecimal.startIndex, offsetBy: 1)
            let hexColor = String(hexadecimal[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
