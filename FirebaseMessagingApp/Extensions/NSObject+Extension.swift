//
//  NSObject+Extension.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
var IDENTIFIER = "IDENTIFIER"
extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
    var identifier: String {
        return String(describing: type(of: self)) + IDENTIFIER.capitalized
    }
    
    class var identifier: String {
        return String(describing: self) + IDENTIFIER.capitalized
    }
}
