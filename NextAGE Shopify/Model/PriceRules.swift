//
//  PriceRules.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 12/09/2024.
//

import Foundation

// MARK: - PriceRules
struct PriceRules: Codable {
    let priceRules: [PriceRule]

    enum CodingKeys: String, CodingKey {
        case priceRules = "price_rules"
    }
}

// MARK: - PriceRuleWrapper
struct PriceRuleWrapper: Codable {
    let priceRule: PriceRule

    enum CodingKeys: String, CodingKey {
        case priceRule = "price_rule"
    }
}

// MARK: - PriceRule
struct PriceRule: Codable {
    let id: Int
    let valueType, value, customerSelection, targetType: String
    let targetSelection, allocationMethod: String
    let oncePerCustomer: Bool
    let startsAt, endsAt, createdAt, updatedAt: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case valueType = "value_type"
        case value
        case customerSelection = "customer_selection"
        case targetType = "target_type"
        case targetSelection = "target_selection"
        case allocationMethod = "allocation_method"
        case oncePerCustomer = "once_per_customer"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case title
    }
}
