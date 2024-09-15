//
//  SignUpViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 08/09/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class SignUpViewModel {
    // MARK: - Properties
    private var networkManager: NetworkManagerProtocol
    private var userDefaultManager: UserDefaultsManager
    var connectivityService: ConnectivityServiceProtocol
    private var customer: Customer?
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    private var userID: Int?
    private var wishlistID: Int?
    private var shoppingCartID: Int?
    
    // MARK: - Closure
    var setIndicator: (Bool)->() = {_ in}
    var navigateToHome: (ValidMessage)->() = {_ in}
    var displayMessage: (ValidMessage, Bool)->() = {_, _ in}

    // MARK: - Initializer
    init() {
        networkManager = NetworkManager.shared
        userDefaultManager = UserDefaultsManager.shared
        connectivityService = ConnectivityService.shared
    }
    
    // MARK: - Public Methods
    func createNewCustomer() {
        // check if email already exist
        setIndicator(true)
        fetchExactEmailCustomers { customers in
            guard let customers = customers else {
                self.displayMessage(.checkingEmailFail, true)
                return
            }
            
            if !customers.isEmpty {
                self.displayMessage(.emailExist, true)
                return
            }
            
            let customerParameters = [
                "first_name": self.firstName,
                "last_name": self.lastName,
                "email": self.email,
                "tags": self.password,
                "note": "",
            ]
            
            // post new customer to shopify
            self.networkManager.postData(to: ShopifyAPI.customers.shopifyURLString(), responseType: CustomerWrapper.self, parameters: ["customer": customerParameters]) { result in
                guard let createdCustomer = result?.customer else {
                    self.displayMessage(.customerCreationFail, true)
                    return
                }
                self.userID = createdCustomer.id
                
                self.createShoppingCartAndWishlist { result in
                    guard let (cartID, wishID) = result else {
                        self.displayMessage(.draftsCreationFail, true)
                        return
                    }
                    self.shoppingCartID = cartID
                    self.wishlistID = wishID
                    
                    let note: [String: [String: String]] = [
                        "customer": [
                            "note":"\(cartID),\(wishID)"
                        ]
                    ]
                    
                    self.networkManager.updateData(at: ShopifyAPI.customer(id: String(createdCustomer.id ?? 0)).shopifyURLString(), with: note) {
                        self.saveToUserDefaults()
                        self.navigateToHome(.successRegister)
                    }
                }
            }
        }
    }
    
    func signInWithGoogle(viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [unowned self] result, error in
            guard error == nil else {
                // ...
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                // At this point, our user is signed in
                if let user = Auth.auth().currentUser {
                    self.firstName = user.displayName ?? ""
                    self.lastName = ""
                    self.email = user.email
                    self.password = user.uid
                    
                    self.signInOrUp()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func signInOrUp() {
        self.setIndicator(true)
        fetchExactEmailCustomers { result in
            guard let customers = result else {
                self.displayMessage(.checkingEmailFail, true)
                return
            }
            if customers.isEmpty || !customers.contains(where: { customer in
                customer.email == self.email?.lowercased()
            }){
                print("sign up")
                self.createNewCustomer()
            } else {
                print("sign in")
                self.signIn(customers: customers)
            }
        }
    }
    
    private func signIn(customers: [Customer]) {
        guard let foundCustomer = customers.first(where: { $0.email == self.email?.lowercased() }) else {
            self.displayMessage(.emailDoesNotExist, true)
            return
        }
        
        if foundCustomer.tags != self.password {
            self.displayMessage(.passwordDoesNotMatch, true)
            return
        }
        
        self.firstName = foundCustomer.firstName
        self.lastName = foundCustomer.lastName
        self.email = foundCustomer.email
        self.password = foundCustomer.tags
        self.userID = foundCustomer.id
        if let draftOrderIDs = foundCustomer.note?.components(separatedBy: ","), draftOrderIDs.count == 2 {
            self.shoppingCartID = Int(draftOrderIDs[0]) ?? 0
            self.wishlistID = Int(draftOrderIDs[1]) ?? 0
        }
        
        self.saveToUserDefaults()
        self.navigateToHome(.successLogin)
    }
    
    private func saveToUserDefaults() {
        userDefaultManager.isLogin = true
        userDefaultManager.name = (firstName ?? "") + " " + (lastName ?? "")
        userDefaultManager.firstName = firstName ?? ""
        userDefaultManager.lastName = lastName ?? ""
        userDefaultManager.email = email ?? ""
        userDefaultManager.phone = ""
        userDefaultManager.password = password ?? ""
        userDefaultManager.customerID = userID ?? 0
        userDefaultManager.wishlistID = wishlistID ?? 0
        userDefaultManager.shoppingCartID = shoppingCartID ?? 0
        userDefaultManager.storeData()
    }
    
    private func fetchExactEmailCustomers(compilation: @escaping ([Customer]?) -> Void) {
        let urlString = ShopifyAPI.customerEmail(email: email ?? "nil").shopifyURLString()
        networkManager.fetchData(from: urlString, responseType: Customers.self, headers: []) { result in
            compilation(result?.customers)
        }
    }
    
    private func createShoppingCartAndWishlist(completion: @escaping ((Int, Int)?) -> Void) {
        let lineItem: [String : Any] =
        [
            "title": "Empty",
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

}
