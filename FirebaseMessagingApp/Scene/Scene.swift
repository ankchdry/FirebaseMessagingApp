//
//  Scene.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import UIKit

enum Scene {
    // Login screen
    case login(LoginViewModel)
    case chatGroups(ChatGroupsViewModel)
    case chatGroupDetails(ChatGroupDetailsViewModel)
}

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        switch self {
            /*******************
             *
             * App Tab View Controllers
             *
             *******************/
            
        case .login(let model):
            var vc = storyboard.instantiateViewController(withIdentifier: LoginViewController.identifier) as! LoginViewController
            vc.bindViewModel(to: model)
            return vc
            
        case .chatGroups(let model):
            var vc = storyboard.instantiateViewController(withIdentifier: ChatGroupsViewController.identifier) as! ChatGroupsViewController
            vc.bindViewModel(to: model)
            return vc
            
        case .chatGroupDetails(let model):
            var vc = storyboard.instantiateViewController(withIdentifier: ChatGroupDetailsViewController.identifier) as! ChatGroupDetailsViewController
            vc.bindViewModel(to: model)
            return vc
        }
    }
}


