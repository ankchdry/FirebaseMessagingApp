//
//  ViewModelType.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation

protocol ViewModelType {
    var identifier: String { get }
}

extension ViewModelType {
    var identifier: String {
        return String(describing: type(of: self)) + IDENTIFIER
    }
}
