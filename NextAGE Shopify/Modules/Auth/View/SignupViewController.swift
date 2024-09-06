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
    private var networkManager: NetworkManager
    private var connectivityService: ConnectivityServiceProtocol
    private var customers:CustomerInfo?

    // MARK: -  View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        loadCustomerData()
    }
    // MARK: - Required init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        connectivityService = ConnectivityService.shared
        super.init(coder: coder)
    }

    // MARK: -  private method
    private func loadCustomerData() {
    }

    private func updateUI(){
        title = "Sign Up"
        registerButton.addCornerRadius(radius: 16)
        for view in cornerRaduisView {
            view.addCornerRadius(radius: 8)
        }
    }
    private func saveCustomerInfo() {
        customers = CustomerInfo(
            firstName:firstNameTextField.text?.trimmingCharacters(in: .whitespaces),
            lastName:secondNameTextField.text?.trimmingCharacters(in: .whitespaces),
            email: emailTextField.text?.trimmingCharacters(in: .whitespaces),
            phone: nil,
            tags:nil,
            id: nil,
            validEmail: nil,
            note: passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        )
//        networkManager.postData(to: ShopifyAPI.newCustomer.shopifyURLString(), responseType: <#T##(Decodable & Encodable).Protocol#>, parameters: <#T##Parameters#>, completion: <#T##((Decodable & Encodable)?) -> Void#>)
    }

    @IBAction func registerWithGoogle(_ sender: UIButton) {
        print("Register with Google")
    }
    // MARK: -  Action
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        connectivityService.checkInternetConnection { [weak self] isConnected in
            if isConnected {
                if self?.validateRegisterFields() ?? false {
                    displayMessage(massage: .succeses, isError: false)
                    self?.saveCustomerInfo()
                }
            } else {
                self?.showNoInternetAlert()
            }
        }
    }
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier:"SignInViewController" , withNav: navigationController)
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
}



