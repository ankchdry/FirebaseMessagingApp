//
//  LoginViewController.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class LoginViewController: UIViewController, BindableType {
    var viewModel: LoginViewModel!
    
    // MARK:- IBOutlets
    @IBOutlet weak var emailTextField: OCTextField!
    @IBOutlet weak var passwordTextField: OCTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK:- RxSwift Props
    var disposeBag = DisposeBag.init()
    
    // MARK: - VC Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - ViewModel Data Binding Methods
    func bindViewModel() {
        // Enable Login Button after validation.
        let emailValidation = emailTextField.rx.text.map{ (!($0!.isEmpty) && ($0!.isValidEmail())) }.share()
        let passwordValidation = passwordTextField.rx.text.map { !($0!.isEmpty) }.share()
        
        // Combine email & password validatin and bind result to enable login button.
        Observable.combineLatest(emailValidation, passwordValidation) { (emailValidation, passwordValidation) -> Bool in
            return emailValidation && passwordValidation
        }.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        
        loginButton.rx.tap.bind { (event) in
            self.viewModel.authenticateUser(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "")
        }.disposed(by: disposeBag)
        
        viewModel.userDetails.filter{ $0 != nil }.bind { (userData) in
            // Move authenticated user to chat group page.
            let sceneCoordinator = (UIApplication.shared.delegate as! AppDelegate).sceneCoordinator
            let chatGroupViewModel = ChatGroupsViewModel.init()
            let chatGroupScene = Scene.chatGroups(chatGroupViewModel)
            sceneCoordinator?.transition(to: chatGroupScene, type: .rootNavigation)
        }.disposed(by: disposeBag)
    }
}
