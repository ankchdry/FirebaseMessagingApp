//
//  BindableType.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//


import Foundation
import UIKit
protocol BindableType {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

