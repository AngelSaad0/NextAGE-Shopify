//
//  AddAddressViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 08/09/2024.
//

import Foundation

class AddAddressViewModel {
    // MARK: - Properties
    let networkManager: NetworkManager
    let userDefaultsManager: UserDefaultsManager
    var isEditing = false
    var address: Address?
    
    // MARK: - Closures
    var setIndicator: (Bool)->() = {_ in}
    var showFailureMessage: ()->() = {}
    var showSuccessMessage: ()->() = {}
    var showSuccessEditingMessage: ()->() = {}
    
    // MARK: - Init
    init() {
        networkManager = NetworkManager()
        userDefaultsManager = UserDefaultsManager.shared
    }
    
    // MARK: - Public Methods
    func addAddress(name: String?, address: String?, city: String?, country: String?, phone: String?, isDefault: Bool, completion: @escaping ()->()) {
        setIndicator(true)
        networkManager.postData(to: ShopifyAPI.addresses(id: userDefaultsManager.customerID).shopifyURLString(), responseType: EmptyResponse.self, parameters: [
            "address":
                [
                    "name": name?.trimmingCharacters(in: .whitespaces) ?? "",
                    "address1": address?.trimmingCharacters(in: .whitespaces) ?? "",
                    "city": city?.trimmingCharacters(in: .whitespaces) ?? "",
                    "country": country?.trimmingCharacters(in: .whitespaces) ?? "",
                    "phone": phone?.trimmingCharacters(in: .whitespaces) ?? "",
                    "default": isDefault
                ]
        ]) { result in
            if result != nil {
                self.showSuccessMessage()
                self.setIndicator(false)
                completion()
            } else {
                self.showFailureMessage()
                self.setIndicator(false)
            }
        }
    }
    
    func editAddress(name: String?, address: String?, city: String?, country: String?, phone: String?, isDefault: Bool, completion: @escaping ()->()) {
        setIndicator(true)
        networkManager.updateData(at: ShopifyAPI.address(addressID: self.address?.id ?? 0, customerID: userDefaultsManager.customerID).shopifyURLString(), with: [
            "address":
                [
                    "name": name?.trimmingCharacters(in: .whitespaces) ?? "",
                    "address1": address?.trimmingCharacters(in: .whitespaces) ?? "",
                    "city": city?.trimmingCharacters(in: .whitespaces) ?? "",
                    "country": country?.trimmingCharacters(in: .whitespaces) ?? "",
                    "phone": phone?.trimmingCharacters(in: .whitespaces) ?? "",
                    "default": isDefault
                ]
        ]) {
            self.showSuccessEditingMessage()
            self.setIndicator(false)
            completion()
        }
    }
}
