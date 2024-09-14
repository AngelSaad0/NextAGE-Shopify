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
    
    // MARK: - Closures
    var setIndicator: (Bool)->() = {_ in}
    var showSuccessMessage: ()->() = {}
    
    // MARK: - Init
    init() {
        networkManager = NetworkManager()
        userDefaultsManager = UserDefaultsManager.shared
    }
    
    // MARK: - Public Methods
    func addAddress(name: String?, address: String?, city: String?, phone: String?, isDefault: Bool, completion: @escaping ()->()) {
        setIndicator(true)
        networkManager.postData(to: ShopifyAPI.addresses(id: userDefaultsManager.customerID).shopifyURLString(), responseType: EmptyResponse.self, parameters: [
            "address":
                [
                    "name": name ?? "",
                    "address1": address ?? "",
                    "city": city ?? "",
                    "phone": phone ?? "",
                    "default": isDefault
                ]
        ]) { _ in
            self.showSuccessMessage()
            self.setIndicator(false)
            completion()
        }
    }
}
