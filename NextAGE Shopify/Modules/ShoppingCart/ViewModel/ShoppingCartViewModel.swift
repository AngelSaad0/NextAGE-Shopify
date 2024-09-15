//
//  ShoppingCartViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 02/09/2024.
//

import Foundation

class ShoppingCartViewModel {
    // MARK: - Properties
    let networkManager: NetworkManagerProtocol
    let userDefaultManager: UserDefaultsManager
    let connectivityService: ConnectivityServiceProtocol
    var shoppingCart: [LineItem] = []
    
    // MARK: - Closures
    var showNoInternetAlert: ()->() = {}
    var setIndicator: (Bool)->() = {_ in}
    var updateReviewButtonState: ()->() = {}
    var bindResultToTableView: ()->() = {}
    var displayMessage: (ValidMessage, Bool)->() = {_, _ in}
    var bindSubtotalPrice: (String)->() = {_ in}
    var displayEmptyMessage: (String)->() = {_ in}
    var removeEmptyMessage: ()->() = {}
    
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
                self.fetchShoppingCart()
            } else {
                self.showNoInternetAlert()
                self.setIndicator(false)
                displayEmptyMessage("Add some products to your shopping cart")
            }
        }
    }
    
    func fetchShoppingCart() {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultManager.shoppingCartID).shopifyURLString(), responseType: DraftOrderWrapper.self, headers: []) { result in
            self.shoppingCart = result?.draftOrder.lineItems ?? []
            if self.shoppingCart.first?.variantID == nil {
                self.shoppingCart = Array(self.shoppingCart.dropFirst())
            }
            self.setIndicator(false)
            if self.shoppingCart.count == 0 {
                self.displayEmptyMessage("Add some products to your shopping cart")
            } else {
                self.removeEmptyMessage()
            }
            self.calcSubTotal()
            self.updateReviewButtonState()
            self.bindResultToTableView()
        }
    }
    
    func removeProduct(at index: Int) {
        var shoppingCartLineItems: [[String: Any]] = []
        for item in shoppingCart {
            var properties : [[String: String]] = []
            if item.variantID != shoppingCart[index].variantID {
                for property in item.properties {
                    properties.append(["name":property.name, "value": property.value])
                }
                shoppingCartLineItems.append(["variant_id": item.variantID ?? 0, "quantity": item.quantity, "properties": properties, "product_id": item.productID ?? 0])
            }
        }
        
        if shoppingCartLineItems.isEmpty {
            shoppingCartLineItems = getEmptyCart()
        }
        
        networkManager.updateData(at: ShopifyAPI.draftOrder(id: userDefaultManager.shoppingCartID).shopifyURLString(), with: ["draft_order": ["line_items": shoppingCartLineItems]]) {
            self.displayMessage(.removedFromShoppingCart, false)
            self.fetchShoppingCart()
        }
    }
    
    // MARK: - Private Methods
    private func calcSubTotal() {
        var sum = 0.0
        for product in shoppingCart {
            sum += (Double(product.price) ?? 0.0) * Double(product.quantity)
        }
        bindSubtotalPrice("Subtotal: " + exchange(sum) + " \(userDefaultManager.currency)")
    }
    
    private func getEmptyCart() -> [[String: Any]] {
        let shoppingCartLineItems: [[String: Any]] = [[
            "title": "Empty",
            "quantity": 1,
            "price": "0",
            "properties":[]
        ]]
        return shoppingCartLineItems
    }
}
