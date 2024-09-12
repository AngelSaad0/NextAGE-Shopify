//
//  SignInViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 08/09/2024.
//

import Foundation

class SignInViewModel {
    // MARK: - Properties
     let networkManager: NetworkManager
     let userDefaultManager: UserDefaultManager
     let connectivityService: ConnectivityServiceProtocol

    var onSuccess: (() -> Void)?
    var onError: ((VaildMassage) -> Void)?

    init(networkManager: NetworkManager, userDefaultManager: UserDefaultManager, connectivityService: ConnectivityServiceProtocol) {
        self.networkManager = networkManager
        self.userDefaultManager = userDefaultManager
        self.connectivityService = connectivityService
    }

    // MARK: - Public Methods
    func validateAndLogin(email: String?, password: String?) {
        guard let email = email?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
            onError?(.emailEmpty)
            return
        }

        guard isValidMobileOrEmail(email) else {
            onError?(.emailValid)
            return
        }

        guard let password = password?.trimmingCharacters(in: .whitespaces), !password.isEmpty else {
            onError?(.passwordEmpty)
            return
        }

        checkUserAuth(email: email, password: password)
    }

    private func checkUserAuth(email: String, password: String) {
        fetchAllCustomers { [weak self] customers in
            guard let self = self else { return }
            guard let customers = customers else {
                self.onError?(.checkingEmailFail)
                return
            }

            guard let foundCustomer = customers.first(where: { $0.email == email.lowercased() }) else {
                self.onError?(.emailDoesNotExist)
                return
            }

            if foundCustomer.tags != password {
                self.onError?(.passwordDoesNotMatch)
                return
            }

            self.saveToUserDefaults(customer: foundCustomer)
            self.onSuccess?()
        }
    }

    private func fetchAllCustomers(completion: @escaping ([CustomerInfo]?) -> Void) {
        let urlString = ShopifyAPI.customers.shopifyURLString()
        networkManager.fetchData(from: urlString, responseType: Customers.self) { result in
            completion(result?.customers)
        }
    }

    private func saveToUserDefaults(customer: CustomerInfo) {
        userDefaultManager.isLogin = true
        userDefaultManager.name = [(customer.firstName ?? ""), (customer.lastName ?? "")].joined(separator: " ")
        userDefaultManager.email = customer.email ?? ""
        userDefaultManager.password = customer.tags ?? ""
        userDefaultManager.customerID = customer.id ?? 0
        if let draftOrderIDs = customer.note?.components(separatedBy: ","), draftOrderIDs.count == 2 {
            userDefaultManager.shoppingCartID = Int(draftOrderIDs[0]) ?? 0
            userDefaultManager.wishlistID = Int(draftOrderIDs[1]) ?? 0
        }
        userDefaultManager.storeData()
    }

    private func isValidMobileOrEmail(_ text: String) -> Bool {
        // Implement your validation logic here
        return true
    }
}
