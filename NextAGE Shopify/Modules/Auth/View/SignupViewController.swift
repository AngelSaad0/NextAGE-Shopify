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
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var rePasswordTextField: UITextField!
    // MARK: -  View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    // MARK: -  private method
    private func updateUI(){
        title = "Sign Up"
        registerButton.addCornerRadius(radius: 16)
        for view in cornerRaduisView {
            view.addCornerRadius(radius: 8)
        }
    }
    private func saveCustomerInfo(){
        
    }
    // MARK: -  Action
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        if validateRegisterFields() {
            displayMessage(massage: .succeses, isError: false)
            saveCustomerInfo()
            
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier:"SignInViewController" , withNav: navigationController)
    }
    
    
    private func validateRegisterFields() -> Bool {
        if userNameTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .nameEmpty, isError: true)
            return false
        }
        if !isValidName(userNameTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
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
        if phoneTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .mobileEmpty, isError: true)
            return false
        }
        if !isValidMobileOrEmail(phoneTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") {
            displayMessage(massage: .mobileVaild, isError: true)
            return false
        }
        if passwordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .passwordEmpty, isError: true)
            return false
        }
        if rePasswordTextField.text?.trimmingCharacters(in: .whitespaces) == "" {
            displayMessage(massage: .reTypeEmpty, isError: true)
            return false
        }
        if !((passwordTextField.text?.trimmingCharacters(in: .whitespaces) ?? "") == (rePasswordTextField.text?.trimmingCharacters(in: .whitespaces) ?? "")) {
            displayMessage(massage: .passwordRetypeEqual, isError: true)
            return false
        }
        return true
    }
}


