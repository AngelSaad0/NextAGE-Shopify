//
//  ShopifyAPI.swift
//  NextAGE Shopify
//
//  Created by Engy on 03/09/2024.
//

import Foundation

enum ShopifyAPI {
    private static let ssl = "https://"
    private static let storeURL = "nciost4.myshopify.com"
    private static let apiVersion = "2024-07"
    private static let apiKey = "f8ba956727eb81aad6e382971df07a3c"
    private static let accessToken = "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"

    case smartCollections
    case products
    case product(id: Int)
    case orders
    case order(id: String)
    case customers
    case customer(id: String)
    case draftOrders
    case draftOrder(id: Int)
    case addresses(id: Int)
    case defaultAddress(addressID: Int, customerID: Int)
    case priceRules
    case priceRule(title: String)

    private var path: String {
        switch self {
        case .smartCollections:
            return "smart_collections.json"
        case .products:
            return "products.json"
        case .product(let id):
            return "products/\(id).json"
        case .orders:
            return "orders.json"
        case .order(let id):
            return "orders/\(id).json"
        case .customers:
            return "customers.json?since_id=1"
        case .customer(id: let id):
            return "customers/\(id).json"
        case .draftOrders:
            return "draft_orders.json"
        case .draftOrder(id: let id):
            return "draft_orders/\(id).json"
        case .addresses(id: let id):
            return "customers/\(id)/addresses.json"
        case .defaultAddress(let addressID, let customerID):
            return "customers/\(customerID)/addresses/\(addressID)/default.json"
        case .priceRules:
            return "price_rules.json"
        case .priceRule(title: let id):
            return "price_rules.json?title=\(id)"
        }
        
    }

    func shopifyURLString() -> String {
        let urlString = "\(ShopifyAPI.ssl)\(ShopifyAPI.apiKey):\(ShopifyAPI.accessToken)@\(ShopifyAPI.storeURL)/admin/api/\(ShopifyAPI.apiVersion)/\(path)"
        return urlString
    }
}
