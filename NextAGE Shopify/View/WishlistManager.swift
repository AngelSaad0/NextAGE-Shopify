//
//  WishlistManager.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/13/24.
//

import Foundation

class WishlistManager {

    // MARK: - Singleton Instance
    static let shared = WishlistManager()

    let networkManager: NetworkManagerProtocol
    let userDefaultsManger:UserDefaultsManager
    var wishlist: [LineItem]?


    private init() {
        networkManager = NetworkManager.shared
        userDefaultsManger = UserDefaultsManager.shared
        fetchWishlist(completion: {})
    }

    func fetchWishlist(completion: @escaping ()->()) {
        networkManager.fetchData(from: ShopifyAPI.draftOrder(id: userDefaultsManger.wishlistID).shopifyURLString(), responseType: DraftOrderWrapper.self, headers: []) { result in
            self.wishlist = result?.draftOrder.lineItems
            completion()
        }
    }
    
    func getFavoriteState(productID: Int) -> Bool {
        for item in wishlist ?? [] {
            if productID == item.productID {
                return true
            }
        }
        return false
    }
    
    func addToWishlist(product: Product, completion: @escaping (Bool)->()) {
        // is in wishlist : so it will be removed
        fetchWishlist {
            if self.getFavoriteState(productID: product.id) {
                var wishlistLineItems: [[String: Any]] = []
                for item in self.wishlist ?? [] {
                    var properties : [[String: String]] = []
                    if item.variantID != nil && item.productID != product.id {
                        for property in item.properties {
                            properties.append(["name":property.name, "value": property.value])
                        }
                        wishlistLineItems.append(["variant_id": item.variantID ?? 0, "quantity": item.quantity, "properties": properties, "product_id": item.productID ?? 0])
                    }
                }
                if wishlistLineItems.isEmpty {
                    wishlistLineItems = [[
                        "title": "Empty",
                        "quantity": 1,
                        "price": "0",
                        "properties":[]
                    ]]
                }
                self.networkManager.updateData(at: ShopifyAPI.draftOrder(id: self.userDefaultsManger.wishlistID).shopifyURLString(), with: ["draft_order": ["line_items": wishlistLineItems]]) {
                    self.fetchWishlist {
                        completion(self.getFavoriteState(productID: product.id))
                    }
                }
            } else {
                // in wishlist : so it will be added
                let newItem: [String: Any] = [
                    "variant_id": product.variants.first?.id ?? 0,
                    "quantity" : 1,
                    "properties":[
                        [
                            "name": "image",
                            "value": product.image.src
                        ],
                        [
                            "name": "inventoryQuantity",
                            "value": product.variants.first?.inventoryQuantity ?? 0]]
                ]
                var wishlistLineItems: [[String: Any]] = []
                for item in self.wishlist ?? [] {
                    var properties : [[String: String]] = []
                    if item.variantID != nil {
                        for property in item.properties {
                            properties.append(["name":property.name, "value": property.value])
                        }
                        wishlistLineItems.append(["variant_id": item.variantID ?? 0, "quantity": item.quantity, "properties": properties, "product_id": item.productID ?? 0])
                    }
                }
                wishlistLineItems.append(newItem)
                self.networkManager.updateData(at: ShopifyAPI.draftOrder(id: self.userDefaultsManger.wishlistID).shopifyURLString(), with: ["draft_order": ["line_items": wishlistLineItems]]) {
                    self.fetchWishlist {
                        completion(self.getFavoriteState(productID: product.id))
                    }
                }
            }
        }
    }
   
}

