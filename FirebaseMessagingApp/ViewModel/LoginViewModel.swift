//
//  LoginViewModel.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa
class LoginViewModel: ViewModelType {
    var userDetails = BehaviorRelay<UserDetails?>.init(value: nil)
    
    func authenticateUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let _ = error { print("Call failed") }
            let userDetails = UserDetails.init(email: authResult?.user.email ?? "", name: authResult?.user.displayName, uid: authResult?.user.uid ?? "")
            userDetails.writeToDisk()
            strongSelf.userDetails.accept(userDetails)
        }
    }
}
