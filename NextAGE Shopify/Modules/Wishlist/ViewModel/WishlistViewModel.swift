//
//  WishlistViewModel.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import Foundation

class WishlistViewModel {
    // MARK: - Properties
    let networkManager: NetworkManagerProtocol
    let userDefaultsManager: UserDefaultsManager
    let connectivityService: ConnectivityServiceProtocol
    var wishlist: [LineItem] = []
    
    // MARK: - Closures
    var showNoInternetAlert: ()->() = {}
    var displayEmptyMessage:((String)->Void) = {_ in}
    var removeEmptyMessage:(()->()) = {}
    var bindResultToTableView:(()->()) = {}
    var setIndicator:((Bool)->()) = {_ in}
    
    // MARK: - Initializer
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
                self.fetchWishlist()
            } else {
                self.showNoInternetAlert()
                self.setIndicator(false)
                displayEmptyMessage("Add some products to your wishlist")
            }
        }
    }
    
    // MARK: - Private Methods
    private func fetchWishlist() {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultsManager.wishlistID).shopifyURLString(), responseType: DraftOrderWrapper.self, headers: []) { result in
            self.wishlist = result?.draftOrder.lineItems ?? []
            if self.wishlist.first?.variantID == nil {
                self.wishlist = Array(self.wishlist.dropFirst())
            }
            self.setIndicator(false)
            if self.wishlist.count == 0 {
                self.displayEmptyMessage("Add some products to your wishlist")
            } else {
                self.removeEmptyMessage()
            }
            self.bindResultToTableView()
        }
    }
}
