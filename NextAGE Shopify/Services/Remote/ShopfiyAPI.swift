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
    case orders
    case order(id: String)

    private var path: String {
        switch self {
        case .smartCollections:
            return "smart_collections.json"
        case .products:
            return "products.json"
        case .orders:
            return "orders.json"
        case .order(let id):
            return "orders/\(id).json"
        }
    }

    func shopifyURLString() -> String {
        let urlString = "\(ShopifyAPI.ssl)\(ShopifyAPI.apiKey):\(ShopifyAPI.accessToken)@\(ShopifyAPI.storeURL)/admin/api/\(ShopifyAPI.apiVersion)/\(path)"
        return urlString
    }
}
