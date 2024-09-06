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
    private var userDefaultManager: UserDefaultManager
    private var connectivityService: ConnectivityServiceProtocol
    private var customer: CustomerInfo?
    private var firstName: String?
    private var lastName: String?
    private var email: String?
    private var password: String?
    
    private var userID: Int?
    private var wishlistID: Int?
    private var shoppingCartID: Int?

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

    // MARK: -  private method
    private func updateUI(){
        title = "Sign Up"
        registerButton.addCornerRadius(radius: 16)
        for view in cornerRaduisView {
            view.addCornerRadius(radius: 8)
        }
    }
    
    private func copyEnteredFields() {
        firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces)
        lastName = secondNameTextField.text?.trimmingCharacters(in: .whitespaces)
        email = emailTextField.text?.trimmingCharacters(in: .whitespaces).lowercased()
        password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
    }
    
    private func saveToUserDefaults() {
        userDefaultManager.isLogin = true
        userDefaultManager.name = (firstName ?? "") + " " + (lastName ?? "")
        userDefaultManager.email = email ?? ""
        userDefaultManager.password = password ?? ""
        userDefaultManager.userID = userID ?? 0
        userDefaultManager.wishlistID = wishlistID ?? 0
        userDefaultManager.shoppingCartID = shoppingCartID ?? 0
        userDefaultManager.storeData()
    }
    
    private func fetchAllCustomers(compilation: @escaping ([CustomerInfo]?) -> Void) {
        let urlString = ShopifyAPI.customers.shopifyURLString()
        networkManager.fetchData(from: urlString, responseType: Customers.self) { result in
            compilation(result?.customers)
        }
    }
    
    private func createNewCustomer() {
        // check if email already exist
        fetchAllCustomers { customers in
            guard let customers = customers else {
                displayMessage(massage: .checkingEmailFail, isError: true)
                return
            }
            
            for customer in customers {
                if customer.email == self.email {
                    displayMessage(massage: .emailExist, isError: true)
                    return
                }
            }
            
            // creating new user
            self.customer = CustomerInfo(
                firstName: self.firstName,
                lastName: self.lastName,
                email: self.email,
                phone: nil,
                tags: self.password,
                id: nil,
                validEmail: nil,
                note: ""
            )
            
            // encoded customer
            guard let encodedCustomer = try? JSONEncoder().encode(self.customer) else {
                displayMessage(massage: .encodingFail, isError: true)
                return
            }
            guard let jsonCustomer = try? JSONSerialization.jsonObject(with: encodedCustomer) as? [String: Any] else {
                displayMessage(massage: .encodingFail, isError: true)
                return
            }
            
            // post new customer to shopify
            self.networkManager.postData(to: ShopifyAPI.customers.shopifyURLString(), responseType: Customer.self, parameters: ["customer": jsonCustomer]) { result in
                guard let createdCustomer = result?.customer else {
                    displayMessage(massage: .customerCreationFail, isError: true)
                    return
                }
                self.userID = createdCustomer.id
                
                self.createShoppingCartAndWishlist { result in
                    guard let (cartID, wishID) = result else {
                        displayMessage(massage: .draftsCreationFail, isError: true)
                        return
                    }
                    self.shoppingCartID = cartID
                    self.wishlistID = wishID
                    
                    let note: [String: [String: String]] = [
                        "customer": [
                            "note":"\(cartID),\(wishID)"
                        ]
                    ]
                    
                    self.networkManager.updateData(at: ShopifyAPI.customer(id: String(createdCustomer.id ?? 0)).shopifyURLString(), with: note)
                }
                
                print("Successfully created new Customer")
                print(createdCustomer)
                
                DispatchQueue.global().async {
                    sleep(3)
                    self.saveToUserDefaults()
                }
                
                DispatchQueue.main.async {
                    UIWindow.setRootViewController(storyboard: "MainTabBar", vcIdentifier: "MainTabBarNavigationController")
                    displayMessage(massage: .successRegister, isError: false)
                }
            }
            
        }

    }
    
    private func createShoppingCartAndWishlist(completion: @escaping ((Int, Int)?) -> Void) {
        let lineItem: [String : Any] =
        [
            "title": "Test",
            "quantity": 1,
            "price": "0",
            "properties":[]
        ]
        
        networkManager.postData(to: ShopifyAPI.draftOrders.shopifyURLString(), responseType: DraftOrderWrapper.self, parameters: ["draft_order": ["line_items": [lineItem]]]) { result in
            guard let shoppingCartDraft = result?.draftOrder else {
                completion(nil)
                return
            }
            
            self.networkManager.postData(to: ShopifyAPI.draftOrders.shopifyURLString(), responseType: DraftOrderWrapper.self, parameters: ["draft_order": ["line_items": [lineItem]]]) { result in
                guard let wishlistDraft = result?.draftOrder else {
                    completion(nil)
                    return
                }
                
                completion((shoppingCartDraft.id, wishlistDraft.id))
            }
        }
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
    
    // MARK: -  Action
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        connectivityService.checkInternetConnection { [weak self] isConnected in
            if isConnected {
                if self?.validateRegisterFields() ?? false {
                    self?.copyEnteredFields()
                    self?.createNewCustomer()
                }
            } else {
                self?.showNoInternetAlert()
            }
        }
    }
    @IBAction func registerWithGoogle(_ sender: UIButton) {
        print("Register with Google")
    }
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        pushViewController(vcIdentifier:"SignInViewController" , withNav: navigationController)
    }

}



