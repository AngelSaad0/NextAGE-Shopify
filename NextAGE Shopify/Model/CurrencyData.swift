//
//  CurrencyData.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 14/09/2024.
//

import Foundation

// MARK: - CurrencyData
struct CurrencyData: Codable {
    let success: Bool
    let query: Query
    let info: Info
    let result: Double
}

// MARK: - Info
struct Info: Codable {
    let timestamp: Int
    let quote: Double
}

// MARK: - Query
struct Query: Codable {
    let from, to: String
    let amount: Int
}

