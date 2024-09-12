//
//  SignUpViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 08/09/2024.
//

import Foundation

class SignUpViewModel {
    // MARK: - Properties
    private var networkManager: NetworkManagerProtocol
    private var userDefaultManager: UserDefaultManager
    var connectivityService: ConnectivityServiceProtocol
    private var customer: CustomerInfo?
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    private var userID: Int?
    private var wishlistID: Int?
    private var shoppingCartID: Int?
    
    // MARK: - Closure
    var navigateToHome: ()->() = {}
    var displayMessage: (VaildMassage, Bool)->() = {_, _ in}

    // MARK: - Initializer
    init() {
        networkManager = NetworkManager.shared
        userDefaultManager = UserDefaultManager.shared
        connectivityService = ConnectivityService.shared
    }
    
    // MARK: - Public Methods
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
    
    private func fetchExactEmailCustomers(compilation: @escaping ([CustomerInfo]?) -> Void) {
        let urlString = ShopifyAPI.customerEmail(email: email ?? "nil").shopifyURLString()
        networkManager.fetchData(from: urlString, responseType: Customers.self, headers: []) { result in
            compilation(result?.customers)
        }
    }
    
    func createNewCustomer() {
        // check if email already exist
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
            self.networkManager.postData(to: ShopifyAPI.customers.shopifyURLString(), responseType: Customer.self, parameters: ["customer": customerParameters]) { result in
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
                        print("Successfully created new Customer")
                        print(createdCustomer)
                        self.navigateToHome()
                    }
                }
            }
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
