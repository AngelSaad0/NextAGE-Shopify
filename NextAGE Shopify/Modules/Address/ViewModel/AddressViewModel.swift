//
//  AddressViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 08/09/2024.
//

import Foundation

class AddressViewModel {
    // MARK: - Properties
    var addresses: [Address] = []
    var defaultAddressIndex: Int?
    var newDefaultAddressIndex: Int?
    var selectedOrderAddress: Int?
    let networkManager: NetworkManagerProtocol
    let userDefaultsManager: UserDefaultsManager
    let connectivityService: ConnectivityServiceProtocol

    // MARK: - Closures
    var showNoInternetAlert: ()->() = {}
    var setIndicator: (Bool)->() = {_ in}
    var setReviewOrderOrDefaultAddressButton: (Bool)->() = {_ in}
    var bindResultToTableView: ()->() = {}
    var showMessage: (ValidMessage, Bool)->() = {_, _ in}
    var displayEmptyMessage: (String)->() = {_ in}
    var removeEmptyMessage: ()->() = {}
    
    // MARK: - Init
    init() {
        networkManager = NetworkManager.shared
        userDefaultsManager = UserDefaultsManager.shared
        connectivityService = ConnectivityService.shared
    }
    
    // MARK: - Public Methods
    func checkInternetConnection() {
        connectivityService.checkInternetConnection { [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                self.fetchAddresses()
            } else {
                self.showNoInternetAlert()
                self.setIndicator(false)
                displayEmptyMessage("No Addresses Found")
            }
        }
    }
    
    func setDefaultAddress() {
        guard let selectedNewAddressIndex = newDefaultAddressIndex else {
            showMessage(.newSelectedAddressFailed, true)
            return
        }
        let addressID = addresses[selectedNewAddressIndex].id
        networkManager.updateData(at: ShopifyAPI.defaultAddress(addressID: addressID, customerID: userDefaultsManager.customerID).shopifyURLString(), with: [:]) {
            self.showMessage(.defaultAddressUpdated, false)
            self.setReviewOrderOrDefaultAddressButton(false)
            self.fetchAddresses()
        }
    }
    
    func fetchAddresses() {
        setIndicator(true)
        networkManager.fetchData(from: ShopifyAPI.addresses(id: userDefaultsManager.customerID).shopifyURLString(), responseType: Addresses.self, headers: []) { result in
            self.setIndicator(false)
            guard let addresses = result?.addresses else {
                self.showMessage(.addressesFetchingFailed, true)
                self.displayEmptyMessage("No Addresses Found")
                return
            }
            if addresses.count == 0 {
                self.displayEmptyMessage("No Addresses Found")
            } else {
                self.removeEmptyMessage()
            }
            self.addresses = addresses
            self.bindResultToTableView()
        }
    }
    
    func submitAddress(completion: @escaping ()->()) {
        var addressParameters: [String: Any] = [:]
        if addresses.indices.contains(selectedOrderAddress ?? -1) {
            addressParameters = [
                "first_name": addresses[selectedOrderAddress!].name ?? "",
                "address1": addresses[selectedOrderAddress!].address1 ?? "",
                "city": addresses[selectedOrderAddress!].city ?? "",
                "phone": addresses[selectedOrderAddress!].phone ?? "",
            ]
        }
        networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultsManager.shoppingCartID).shopifyURLString(), with: ["draft_order": ["shipping_address": addressParameters]]) {
            completion()
        }
    }
    
    func deleteAddress(at index: Int) {
        let customerID = userDefaultsManager.customerID
        let addressID = addresses[index].id
        networkManager.deleteData(at: ShopifyAPI.address(addressID: addressID, customerID: customerID).shopifyURLString()) {
            self.fetchAddresses()
        }
    }
}
