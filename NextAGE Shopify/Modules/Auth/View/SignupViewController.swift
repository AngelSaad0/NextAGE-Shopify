//
//  SignUpViewController.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 9/1/24.
//

import UIKit

class SignUpViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet var cornerRaduisView:[UIView]!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var secondNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var rePasswordTextField: UITextField!
    
    // MARK: -  Properties
    let viewModel: SignUpViewModel
    let indicator = UIActivityIndicatorView(style: .large)

    // MARK: -  View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupViewModel()
    }
    
    // MARK: - Required init
    required init?(coder: NSCoder) {
        viewModel = SignUpViewModel()
        super.init(coder: coder)
    }

    // MARK: -  private method
    private func updateUI(){
        title = "Sign Up"
        registerButton.addCornerRadius(radius: 16)
        for view in cornerRaduisView {
            view.addCornerRadius(radius: 8)
        }
        setupIndicator()
    }
    
    private func setupIndicator() {
        indicator.center = view.center
        view.addSubview(indicator)
    }
    
    private func setupViewModel() {
        viewModel.navigateToHome = { message in
            DispatchQueue.main.async {
                UIWindow.setRootViewController(storyboard: "Main", vcIdentifier: "MainTabBarNavigationController")
                displayMessage(massage: message, isError: false)
            }
        }
        viewModel.displayMessage = { message, isError in
            displayMessage(massage: message, isError: isError)
            self.indicator.stopAnimating()
        }
        viewModel.setIndicator = { state in
            DispatchQueue.main.async { [weak self] in
                state ? self?.indicator.startAnimating() : self?.indicator.stopAnimating()
            }
        }
    }
    
    private func copyEnteredFields() {
        viewModel.firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces)
        viewModel.lastName = secondNameTextField.text?.trimmingCharacters(in: .whitespaces)
        viewModel.email = emailTextField.text?.trimmingCharacters(in: .whitespaces).lowercased()
        viewModel.password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
    }
    
    private func validateRegisterFields() -> Bool {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .nameEmpty, isError: true)
            return false
        }
        if !isValidName(firstNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            displayMessage(massage: .nameVaild, isError: true)
            return false
        }
        if secondNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .nameEmpty, isError: true)
            return false
        }
        if !isValidName(secondNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            displayMessage(massage: .nameVaild, isError: true)
            return false
        }
        if emailTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .emailEmpty, isError: true)
            return false
        }
        if !isValidMobileOrEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
            displayMessage(massage: .emailValid, isError: true)
            return false
        }
        if passwordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .passwordEmpty, isError: true)
            return false
        }
        if !isValidPassword(passwordTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            displayMessage(massage: .passwordVaild, isError: true)
            return false
        }
        if rePasswordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .reTypeEmpty, isError: true)
            return false
        }
        if !isValidPassword(rePasswordTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            displayMessage(massage: .passwordVaild, isError: true)
            return false
        }
        if !((passwordTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") == (rePasswordTextField.text?.trimmingCharacters(in: .whitespaces) ?? "")) {
            displayMessage(massage: .passwordRetypeEqual, isError: true)
            return false
        }
        return true
    }
    
    private func holdRegisterButton() {
        registerButton.isEnabled = false
        registerButton.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.registerButton.isEnabled = true
            self.registerButton.alpha = 1
        }
    }
    
    // MARK: -  IBActions
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        viewModel.connectivityService.checkInternetConnection { [weak self] isConnected in
            if isConnected {
                if self?.validateRegisterFields() ?? false {
                    self?.holdRegisterButton()
                    self?.copyEnteredFields()
                    self?.viewModel.createNewCustomer()
                }
            } else {
                self?.showNoInternetAlert()
            }
        }
    }
    
    @IBAction func registerWithGoogle(_ sender: UIButton) {
        print("Register with Google")
        viewModel.signInWithGoogle(viewController: self)
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier:"SignInViewController" , withNav: navigationController)
    }

}



