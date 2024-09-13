//
//  WishlistViewModel.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 08/09/2024.
//

import Foundation
class WishlistViewModel {
    
    // MARK: -  Properties
    let networkManager: NetworkManagerProtocol
    let userDefaultsManager: UserDefaultManager
    let connectivityService: ConnectivityServiceProtocol
    var wishlist: [LineItem] = []
    var displayEmptyMessage:((String)->Void) = {_ in}
    var removeEmptyMessage:(()->()) = {}
    var bindResultToTableView:(()->()) = {}
    var setIndicator:((Bool)->()) = {_ in}
    
    
    
    // MARK: -  initalzation
    init(networkManager: NetworkManager = NetworkManager(),
         userDefaultsManager: UserDefaultManager = UserDefaultManager.shared,
         connectivityService: ConnectivityServiceProtocol = ConnectivityService.shared) {
        self.networkManager = networkManager
        self.userDefaultsManager = userDefaultsManager
        self.connectivityService = connectivityService
    }
    
    // MARK: -  public Method
    func fetchWishlist() {
        setIndicator(true)
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
