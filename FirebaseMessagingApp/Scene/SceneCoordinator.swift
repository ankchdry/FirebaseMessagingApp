//
//  SceneCoordinator.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    
    fileprivate var window: UIWindow
    fileprivate var currentViewController: UIViewController
    fileprivate var currentNavigationController: UINavigationController? {
        return currentViewController.navigationController
    }
    
    required init(window: UIWindow) {
        self.window = window
        self.currentViewController = window.rootViewController ?? UIViewController.init()
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return viewController
        }
    }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()
        switch type {
        case .root:
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            subject.onCompleted()
            
        case .push:
            guard let navigationController = currentNavigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            
            // One-off subscription to be notified when push complete.
            _ = navigationController.rx.delegate.sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: true)
            //            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            
        case .modal:
            currentViewController.present(viewController, animated: true) {
                subject.onCompleted()
            }
            //            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            
        case .rootNavigation:
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            window.rootViewController = UINavigationController.init(rootViewController: viewController)
            window.makeKeyAndVisible()
            subject.onCompleted()
        }
        
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    @discardableResult
    func pop(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>.init()
        if let presenter = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: true) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else if let navigationController = currentNavigationController {
            // Navigate up the stack
            // one-off subscription to be notified when pop complete
            _ = navigationController.rx.delegate.sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            guard navigationController.popViewController(animated: true) != nil else  {
                fatalError("can't navigate back from \(currentViewController)")
            }
            //            currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
        return subject.asObservable().take(1).ignoreElements()
    }
}
