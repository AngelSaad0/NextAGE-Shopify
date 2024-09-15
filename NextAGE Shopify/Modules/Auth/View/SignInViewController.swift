//
//  SignInViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 9/1/24.
//

import UIKit

class SignInViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var hidePasswordButton: UIButton!

    // MARK: - Properties
    private var viewModel: SignInViewModel
    private var isSecurePasswordText = true

    // MARK: - Required Init
    required init?(coder: NSCoder) {
        viewModel = SignInViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
        setupKeyboardDismissal()
    }

    // MARK: - Private Methods
    private func updateUI() {
        title = "Sign In"
        loginButton.addCornerRadius(radius: 16)
        emailView.addCornerRadius(radius: 8)
        passwordView.addCornerRadius(radius: 8)
    }

    private func setupViewModel() {
        viewModel.onSuccess = {
            DispatchQueue.main.async {
                UIWindow.setRootViewController(storyboard: "Main", vcIdentifier: "MainTabBarNavigationController")
                displayMessage(massage: .successLogin, isError: false)
            }
        }

        viewModel.onError = {  message in
            DispatchQueue.main.async {
                displayMessage(massage: message, isError: true)
            }
        }
    }

    // MARK: - IBActions
    @IBAction func hidePasswordButtonClicked(_ sender: UIButton) {
        isSecurePasswordText.toggle()
        hidePasswordButton.setImage(UIImage(systemName: isSecurePasswordText ? "eye.slash" : "eye"), for: .normal)
        passwordTextField.isSecureTextEntry = isSecurePasswordText
    }

    @IBAction func loginButtonClicked(_ sender: UIButton) {
        viewModel.connectivityService.checkInternetConnection{ [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                let email = self.emailTextField.text
                let password = self.passwordTextField.text
                self.viewModel.validateAndLogin(email: email, password: password)
            } else {
                self.showNoInternetAlert()
            }
        }
    }

    @IBAction func registerButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "SignUpViewController", withNav: navigationController)
    }

    @IBAction func forgetPasswordButtonClicked(_ sender: UIButton) {
        // Handle forgot password action if API supports it
    }

    @IBAction func guestButtonClicked(_ sender: UIButton) {
        viewModel.userDefaultManager.continueAsAGuest = true
        viewModel.userDefaultManager.storeData()
        UIWindow.setRootViewController(vcIdentifier: "MainTabBarNavigationController")
    }
}
