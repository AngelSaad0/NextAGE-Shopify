//
//  Products.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/4/24.
//

import Foundation
struct Products: Codable {
    let products: [ProductInfo]
}

struct Product: Codable {
    let product: ProductInfo
}

struct ProductInfo: Codable {
    let id: Int
    let title, bodyHTML, vendor: String
    let productType: ProductType
    let createdAt: String
    let handle: String
    let updatedAt, publishedAt: String
    let tags: String
    let status: Status
    let adminGraphqlAPIID: String
    let variants: [Variant]
    let options: [Option]
    let images: [ProductImage]
    let image: ProductImage
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case tags, status
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case variants, options, images, image
    }
}

// MARK: - Image
struct ProductImage: Codable {
    let id: Int
    let position, productID: Int
    let createdAt, updatedAt: String
    let adminGraphqlAPIID: String
    let width, height: Int
    let src: String
    
    enum CodingKeys: String, CodingKey {
        case id, position
        case productID = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case width, height, src
    }
}

// MARK: - Option
struct Option: Codable {
    let id, productID: Int
    let name: Name
    let position: Int
    let values: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

enum Name: String, Codable {
    case color = "Color"
    case size = "Size"
}

enum ProductType: String, Codable {
    case accessories = "ACCESSORIES"
    case shoes = "SHOES"
    case tShirts = "T-SHIRTS"
}

enum Status: String, Codable {
    case active = "active"
}

// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int
    let title, price: String
    let position: Int
    let inventoryPolicy: InventoryPolicy
    let compareAtPrice: String?
    let option1: String
    let option2: String
    let createdAt, updatedAt: String
    let taxable: Bool
    let fulfillmentService: FulfillmentService
    let grams: Int
    let inventoryManagement: InventoryManagement
    let requiresShipping: Bool
    let sku: String
    let weight: Int
    let weightUnit: String
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int
    let adminGraphqlAPIID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case option1, option2
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable
        case fulfillmentService = "fulfillment_service"
        case grams
        case inventoryManagement = "inventory_management"
        case requiresShipping = "requires_shipping"
        case sku, weight
        case weightUnit = "weight_unit"
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}

enum FulfillmentService: String, Codable {
    case manual = "manual"
}

enum InventoryManagement: String, Codable {
    case shopify = "shopify"
}

enum InventoryPolicy: String, Codable {
    case deny = "deny"
}


