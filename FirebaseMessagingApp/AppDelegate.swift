//
//  AppDelegate.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 23/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var sceneCoordinator: SceneCoordinator!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Configured Fireabase Database
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        // Offline data persistence.
        Database.database().isPersistenceEnabled = true
        
        // Initialize SceneCordinator.
        sceneCoordinator = SceneCoordinator.init(window: window!)
        UserDetails.readFromDisk() == nil ? self.setLoginAsRootView() : setChatWithNavAsRootView()
        return true
    }
    
    func setLoginAsRootView() {
        let loginViewModel = LoginViewModel.init()
        let loginScene = Scene.login(loginViewModel)
        sceneCoordinator.transition(to: loginScene, type: .root)
    }
    
    func setChatWithNavAsRootView() {
        let chatGroupViewModel = ChatGroupsViewModel.init()
        let chatGroupScene = Scene.chatGroups(chatGroupViewModel)
        sceneCoordinator?.transition(to: chatGroupScene, type: .rootNavigation)
    }
}

