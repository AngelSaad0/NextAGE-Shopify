//
//  BrandsCollection.swift
//  NextAGE Shopify
//
//  Created by Engy on 03/09/2024.
//

import Foundation

// MARK: - BrandsCollection
struct BrandsCollection: Codable {
    let smartCollections: [SmartCollection]
    
    enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
    }
}

// MARK: - SmartCollection
struct SmartCollection: Codable {
    let id: Int
    let handle, title: String
    let updatedAt: String
    let bodyHTML: String
    let publishedAt: String
    let sortOrder: SortOrder
    let disjunctive: Bool
    let rules: [Rule]
    let publishedScope: PublishedScope
    let adminGraphqlAPIID: String
    let image: CollectionImage
    
    enum CodingKeys: String, CodingKey {
        case id, handle, title
        case updatedAt = "updated_at"
        case bodyHTML = "body_html"
        case publishedAt = "published_at"
        case sortOrder = "sort_order"
        case disjunctive, rules
        case publishedScope = "published_scope"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case image
    }
}

// MARK: - Image
struct CollectionImage: Codable {
    let createdAt: String
    let width, height: Int
    let src: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case width, height, src
    }
}

enum PublishedScope: String, Codable {
    case web = "web"
}

// MARK: - Rule
struct Rule: Codable {
    let column: Column
    let relation: Relation
    let condition: String
}

enum Column: String, Codable {
    case title = "title"
}

enum Relation: String, Codable {
    case contains = "contains"
}

enum SortOrder: String, Codable {
    case bestSelling = "best-selling"
}
