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
    let userDefaultManager: UserDefaultManager
    var shoppingCart: [LineItem] = []
    
    // MARK: - Closures
    var setIndicator: (Bool)->() = {_ in}
    var updateReviewButtonState: ()->() = {}
    var bindResultToTableView: ()->() = {}
    var displayMessage: (VaildMassage, Bool)->() = {_, _ in}
    var bindSubtotalPrice: (String)->() = {_ in}
    
    // MARK: - Initializer
    init() {
        networkManager = NetworkManager.shared
        userDefaultManager = UserDefaultManager.shared
    }
    
    // MARK: - Public Methods
    func fetchShoppingCart() {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultManager.shoppingCartID).shopifyURLString(), responseType: DraftOrderWrapper.self, headers: []) { result in
            self.shoppingCart = result?.draftOrder.lineItems ?? []
            if self.shoppingCart.first?.variantID == nil {
                self.shoppingCart = Array(self.shoppingCart.dropFirst())
            }
            self.setIndicator(false)
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
        bindSubtotalPrice("Subtotal: " + String(format: "%.2f", sum) + " \(UserDefaultManager.shared.currency)")
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
