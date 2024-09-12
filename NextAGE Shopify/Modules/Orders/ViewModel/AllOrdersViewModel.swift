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
    let userDefaultManager: UserDefaultManager
    var orders: [Order] = []
    var setIndicator: (Bool)->() = {_ in}
    var showMessage: (String)->() = {_ in}
    var displayMessage: (VaildMassage, Bool)->() = {_, _ in}
    var removeMessage: ()->() = {}
    var bindResultToTableView: ()->() = {}
    
    // MARK: - Initializer
    init() {
        networkManager = NetworkManager.shared
        userDefaultManager = UserDefaultManager.shared
    }
    
    // Public Methods
    func fetchAllOrders(completion: @escaping ([Order]?)->()) {
        networkManager.fetchData(from: ShopifyAPI.orders.shopifyURLString(), responseType: Orders.self, headers: []) { result in
            completion(result?.orders)
        }
    }
    
    func updateUserOrders() {
        setIndicator(true)
        fetchAllOrders { orders in
            self.setIndicator(false)
            guard let orders = orders else {
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
