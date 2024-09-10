//
//  UIWindow+Extension.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/5/24.
//

import Foundation
import UIKit
extension UIWindow {
    static func setRootViewController(storyboard: String = "Main", vcIdentifier: String, withTransition transition: UIView.AnimationOptions = .transitionCrossDissolve, duration: TimeInterval = 0.3) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let story = UIStoryboard(name: storyboard, bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: vcIdentifier)
                UIView.transition(with: window, duration: duration, options: transition, animations: {
                    window.rootViewController = vc
                }, completion: nil)

                window.makeKeyAndVisible()
            }
        }
}
