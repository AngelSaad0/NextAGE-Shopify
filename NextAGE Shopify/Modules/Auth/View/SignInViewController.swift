//
//  SignInViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 9/1/24.
//

import UIKit

class SignInViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var emailView: UIView!
    

    // MARK: -  View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: -  Privte method
    private func updateUI() {
        title = "Sign In"
        loginButton.addCornerRadius(radius: 16)
        emailView.addCornerRadius(radius: 8)
        passwordView.addCornerRadius(radius: 8)
    }

    // MARK: -  Action
    @IBAction func loginButtonClicked(_ sender: UIButton) {
    }

    @IBAction func registerButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "SignUpViewController", withNav: navigationController)

    }

    @IBAction func forgetPasswordButtonClicked(_ sender: UIButton) {
#warning("may be delet if api cant do so")
    }


    @IBAction func guestButtonClicked(_ sender: UIButton) {
#warning("uncomment user default")
        // UserDefaultManager.shared.continueAsAGuest = true
        UserDefaultManager.shared.storeData()
        UIWindow.setRootViewController(storyboard:"MainTabBar", vcIdentifier : "MainTabBarNavigationController")


    }

}
