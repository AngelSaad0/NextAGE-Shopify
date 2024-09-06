//
//  Customer.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 9/6/24.
//
struct Customers: Codable{
    let customers: [CustomerInfo]?
}

struct Customer: Codable{
    let customer: CustomerInfo
}

struct CustomerInfo: Codable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let phone: String?
    let tags: String?
    let id: Int?
    let validEmail: Bool?
    let note: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phone
        case tags
        case id
        case validEmail = "verified_email"
        case note
    }
}
