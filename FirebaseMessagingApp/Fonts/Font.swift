//
//  Font.swift
//  oxfordCaps
//
//  Created by Ankit Chaudhary on 01/04/19.
//  Copyright © 2019 Ankit  Chaudhary. All rights reserved.
//

import Foundation
import UIKit

enum FontName:String {
    case SharpSans = "SharpSans"
}

enum FontSize:Int {
    case small = 8
    case medium = 12
    case large = 15
}

enum Font {
    case book(size: CGFloat, font:FontName)
    case blackItalic(size: CGFloat, font:FontName)
    case bold(size: CGFloat, font:FontName)
    case semiBold(size: CGFloat, font:FontName)
    case boldItalic(size: CGFloat, font:FontName)
    case italic(size: CGFloat, font:FontName)
    case light(size: CGFloat, font:FontName)
    case lightItalic(size: CGFloat, font:FontName)
    case medium(size: CGFloat, font:FontName)
    case mediumItalic(size: CGFloat, font:FontName)
    case regular(size: CGFloat, font:FontName)
    case thin(size: CGFloat, font:FontName)
    case thinItalic(size: CGFloat, font:FontName)
    
    func fetch() -> UIFont {
        switch self {
        case .book(let size, let font):
            return UIFont(name: font.rawValue+"-Book", size: CGFloat(size))!
            
        case .blackItalic(let size, let font):
            return UIFont(name: font.rawValue+"-BlackItalic", size: CGFloat(size))!
            
        case .bold(let size, let font):
            return UIFont(name: font.rawValue+"-Bold", size: CGFloat(size))!
            
        case .semiBold(let size, let font):
            return UIFont(name: font.rawValue+"-Semibold", size: CGFloat(size))!
            
        case .boldItalic(let size, let font):
            return UIFont(name: font.rawValue+"-BoldItalic", size: CGFloat(size))!
            
        case .light(let size, let font):
            return UIFont(name: font.rawValue+"-Light", size: CGFloat(size))!
            
        case .medium(let size, let font):
            return UIFont(name: font.rawValue+"-Medium", size: CGFloat(size))!
            
        case .mediumItalic(let size, let font):
            return UIFont(name: font.rawValue+"-MediumItalic", size: CGFloat(size))!
            
        case .regular(let size, let font):
            return UIFont(name: font.rawValue+"-Regular", size: CGFloat(size))!
            
        case .thin(let size, let font):
            return UIFont(name: font.rawValue+"-Thin", size: CGFloat(size))!
            
        case .thinItalic(let size, let font):
            return UIFont(name: font.rawValue+"-ThinItalic", size: CGFloat(size))!
            
        default:
            break
        }
        return UIFont()
    }
}
