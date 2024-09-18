//
//  Addresses.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 11/09/2024.
//

import Foundation

// MARK: - Addresses
struct Addresses: Codable {
    let addresses: [Address]
}

// MARK: - Address
struct Address: Codable {
    let id, customerID: Int
    let address1: String?
    let city: String?
    let country, phone, name: String?
    let addressDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case address1, city, country, phone, name
        case addressDefault = "default"
    }
}

// MARK: - ShippingAddress
struct ShippingAddress: Codable {
    let address1: String?
    let city: String?
    let phone: String?
    let firstName: String?
    
    enum CodingKeys: String, CodingKey {
        case address1
        case city
        case phone
        case firstName = "first_name"
    }
}
