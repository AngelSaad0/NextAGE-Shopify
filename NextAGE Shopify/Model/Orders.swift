//
//  Orders.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/6/24.
//

import Foundation


// MARK: - Orders
struct Orders: Codable {
    var orders: [Order]
}

// MARK: - OrderWrapper
struct OrderWrapper: Codable {
    var order: Order
}

// MARK: - Order
struct Order: Codable {
    let id: Int
    let orderNumber: Int
    let lineItems: [LineItem]
    let createdAt: String
    let currency: String
    let currentSubtotalPrice: String
    let name: String
    let subtotalPrice: String
    let totalPrice: String
    let customer: CustomerInfo
    let currentTotalDiscounts: String
    let totalDiscounts: String
    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        case lineItems = "line_items"
        case createdAt = "created_at"
        case currency
        case currentSubtotalPrice = "current_subtotal_price"
        case name
        case totalDiscounts = "total_discounts"
        case customer
        case currentTotalDiscounts = "current_total_discounts"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
    }
}
struct LineItem: Codable {
    let id: Int
    let variantID: Int?
    let productID: Int?
    var price: String
    let name, title: String?
    var quantity: Int
    let properties: [NoteAttribute]


    enum CodingKeys: String, CodingKey {
        case id
        case variantID = "variant_id"
        case productID = "product_id"
        case name, price, title
        case properties
        case quantity

    }
}

