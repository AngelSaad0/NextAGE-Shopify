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
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var hidePasswordButton: UIButton!
    // MARK: -  properties
    var isSecurePasswordText = true
    private var networkManager: NetworkManager
    private var userDefaultManager: UserDefaultManager
    private var connectivityService: ConnectivityServiceProtocol
    private var email: String?
    private var password: String?

    // MARK: -  View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    // MARK: - Required init
    required init?(coder: NSCoder) {
        networkManager = NetworkManager()
        userDefaultManager = UserDefaultManager.shared
        connectivityService = ConnectivityService.shared
        super.init(coder: coder)
    }

    // MARK: -  Privte method
    private func updateUI() {
        title = "Sign In"
        loginButton.addCornerRadius(radius: 16)
        emailView.addCornerRadius(radius: 8)
        passwordView.addCornerRadius(radius: 8)
    }

    private func copyEnteredFields() {
        email = emailTextField.text?.trimmingCharacters(in: .whitespaces)
        password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
    }
    
    private func saveToUserDefaults(customer: CustomerInfo) {
        userDefaultManager.isLogin = true
        userDefaultManager.name = (customer.firstName ?? "") + " " + (customer.lastName ?? "")
        userDefaultManager.email = customer.email ?? ""
        userDefaultManager.password = customer.tags ?? ""
        userDefaultManager.userID = customer.id ?? 0
        if let draftOrderIDs = customer.note?.components(separatedBy: ","), draftOrderIDs.count == 2 {
            userDefaultManager.shoppingCartID = Int(draftOrderIDs[0]) ?? 0
            userDefaultManager.wishlistID = Int(draftOrderIDs[1]) ?? 0
        }
        userDefaultManager.storeData()
    }
    
    private func fetchAllCustomers(compilation: @escaping ([CustomerInfo]?) -> Void) {
        let urlString = ShopifyAPI.customers.shopifyURLString()
        networkManager.fetchData(from: urlString, responseType: Customers.self) { result in
            compilation(result?.customers)
        }
    }
    
    private func validateLoginFields() -> Bool {
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
        return true
    }
    
    private func checkUserAuth() {
        fetchAllCustomers { customers in
            guard let customers = customers else {
                displayMessage(massage: .checkingEmailFail, isError: true)
                return
            }
            
            var foundCustomer: CustomerInfo?
            for customer in customers {
                if customer.email == self.email?.lowercased() {
                    foundCustomer = customer
                    break
                }
            }
            
            if foundCustomer == nil {
                displayMessage(massage: .emailDoesNotExist, isError: true)
            } else {
                guard foundCustomer!.tags == self.password else {
                    displayMessage(massage: .passwordDoesNotMatch, isError: true)
                    return
                }
                
                self.saveToUserDefaults(customer: foundCustomer!)
                
                DispatchQueue.main.async {
                    UIWindow.setRootViewController(storyboard: "MainTabBar", vcIdentifier: "MainTabBarNavigationController")
                    displayMessage(massage: .successLogin, isError: false)
                }
            }
        }
    }
    
    // MARK: -  Action
    @IBAction func hidePasswordButtonClicked(_ sender: UIButton) {
        isSecurePasswordText.toggle()
        hidePasswordButton.setImage(UIImage(systemName: isSecurePasswordText ? ("eye.slash"):("eye")), for:.normal)
        passwordTextField.isSecureTextEntry = isSecurePasswordText

    }
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        connectivityService.checkInternetConnection { [weak self] isConnected in
            if isConnected {
                if self?.validateLoginFields() ?? false {
                    self?.copyEnteredFields()
                    self?.checkUserAuth()
                }
            } else {
                self?.showNoInternetAlert()
            }
        }
        
    }

    @IBAction func registerButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier: "SignUpViewController", withNav: navigationController)

    }

    @IBAction func forgetPasswordButtonClicked(_ sender: UIButton) {
#warning("may be delet if api cant do so")
    }


    @IBAction func guestButtonClicked(_ sender: UIButton) {
        UserDefaultManager.shared.continueAsAGuest = true
        UserDefaultManager.shared.storeData()
        UIWindow.setRootViewController(storyboard:"MainTabBar", vcIdentifier : "MainTabBarNavigationController")


    }

}
