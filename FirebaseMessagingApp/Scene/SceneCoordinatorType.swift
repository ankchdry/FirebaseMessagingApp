//
//  SceneCoordinatorType.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    // Transition to another scene
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    // Pop scene from navigation from stack or dismissal of current modal.
    @discardableResult
    func pop(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Completable {
        return pop(animated: true)
    }
}
