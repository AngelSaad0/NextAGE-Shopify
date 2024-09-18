//
//  AllOrdersViewModel.swift
//  NextAGE Shopify
//
//  Created by Engy on 08/09/2024.
//

import Foundation

class AllOrdersViewModel {
    // MARK: - Properties
    let networkManager: NetworkManagerProtocol
    let userDefaultManager: UserDefaultsManager
    var connectivityService: ConnectivityServiceProtocol
    var orders: [Order] = []
    
    // MARK: - Closures
    var showNoInternetAlert: ()->() = {}
    var setIndicator: (Bool)->() = {_ in}
    var showMessage: (String)->() = {_ in}
    var displayMessage: (ValidMessage, Bool)->() = {_, _ in}
    var removeMessage: ()->() = {}
    var bindResultToTableView: ()->() = {}
    
    // MARK: - Initializer
    init() {
        networkManager = NetworkManager.shared
        userDefaultManager = UserDefaultsManager.shared
        connectivityService = ConnectivityService.shared
    }
    
    // MARK: - Public Methods
    func checkInternetConnection() {
        connectivityService.checkInternetConnection { [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                self.updateUserOrders()
            } else {
                self.showNoInternetAlert()
                self.setIndicator(false)
                showMessage("No Orders Yet ")
            }
        }
    }
    
    func fetchAllOrders(completion: @escaping ([Order]?)->()) {
        networkManager.fetchData(from: ShopifyAPI.orders.shopifyURLString(), responseType: Orders.self, headers: []) { result in
            completion(result?.orders)
        }
    }
    
    // MARK: - Private Methods
    private func updateUserOrders() {
        setIndicator(true)
        fetchAllOrders { orders in
            self.setIndicator(false)
            guard let orders = orders else {
                self.showMessage("No Orders Yet ")
                self.displayMessage(.ordersFetchingFailed, true)
                return
            }
            self.orders = orders.filter {$0.customer.id == self.userDefaultManager.customerID}
            if self.orders.count == 0 {
                self.showMessage("No Orders Yet ")
            } else {
                self.removeMessage()
            }
            self.bindResultToTableView()
        }
    }
}
