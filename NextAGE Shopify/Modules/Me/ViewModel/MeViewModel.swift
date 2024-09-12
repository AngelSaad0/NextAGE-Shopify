//
//  MeViewModel.swift
//  NextAGE Shopify
//
//  Created by Engy on 08/09/2024.
//

import Foundation

class MeViewModel {

    // MARK: - Properties
    private let networkManager: NetworkManagerProtocol
    private let userDefaultsManager: UserDefaultManager
    private let connectivityService: ConnectivityServiceProtocol

    var orders: [Order] = []
    var wishlist: [LineItem] = []
    var customerName: String?
    var isUserLoggedIn: Bool = false
    var currentCustomerId: Int?

    // MARK: - Callbacks
    var onOrdersUpdated: (() -> Void)?
    var onWishlistUpdated: (() -> Void)?
    var onInternetConnectionChecked: (() -> Void)?
    var onShowNoInternetAlert: (() -> Void)?

    // MARK: - Initialization
    init(networkManager: NetworkManager, userDefaultsManager: UserDefaultManager, connectivityService: ConnectivityServiceProtocol) {
        self.networkManager = networkManager
        self.userDefaultsManager = userDefaultsManager
        self.connectivityService = connectivityService
        setupInitialState()
    }

    private func setupInitialState() {
        isUserLoggedIn = userDefaultsManager.isLogin
        currentCustomerId = userDefaultsManager.customerID
        customerName = userDefaultsManager.name.isEmpty ? nil : userDefaultsManager.name
    }

    func checkInternetConnection() {
        connectivityService.checkInternetConnection { [weak self] isConnected in
            guard let self = self else { return }
            if isConnected {
                self.onInternetConnectionChecked?()
            } else {
                self.onShowNoInternetAlert?()
            }
        }
    }

    func updateUserOrders() {
        fetchAllOrders { [weak self] orders in
            guard let self = self else { return }
            if let orders = orders {
                self.orders = orders.filter { $0.customer.id == self.currentCustomerId }
                self.onOrdersUpdated?()
            } else {
                self.orders = []
                Task { @MainActor in
                                displayMessage(massage: .ordersFetchingFailed, isError: true)
                            }
                self.onOrdersUpdated?()
            }
        }
    }

    func loadWishlistData() {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultsManager.wishlistID).shopifyURLString(), responseType: DraftOrderWrapper.self, headers: []) { [weak self] result in
            guard let self = self else { return }
            self.wishlist = result?.draftOrder.lineItems ?? []
            if self.wishlist.first?.variantID == nil {
                self.wishlist = Array(self.wishlist.dropFirst())
            }
            self.onWishlistUpdated?()
        }
    }

    private func fetchAllOrders(completion: @escaping ([Order]?)->()) {
        networkManager.fetchData(from: ShopifyAPI.orders.shopifyURLString(), responseType: Orders.self, headers: []) { result in
            completion(result?.orders)
        }
    }
}
