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
//    let firstName, lastName: String
//    let company: JSONNull?
    let address1: String?
//    let address2: JSONNull?
    let city: String?
//    let province: JSONNull?
    let country, /*zip,*/ phone, name: String?
//    let provinceCode: JSONNull?
//    let countryCode, countryName: String
    let addressDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
//        case firstName = "first_name"
//        case lastName = "last_name"
        case /*company,*/ address1/*, address2*/, city, /*province,*/ country, /*zip,*/ phone, name
//        case provinceCode = "province_code"
//        case countryCode = "country_code"
//        case countryName = "country_name"
        case addressDefault = "default"
    }
}

// MARK: - ShippingAddress
struct ShippingAddress: Codable {
    let address1: String?
    let city: String?
    let phone: String?
    let name: String?
}


//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//            return true
//    }
//
//    public var hashValue: Int {
//            return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if !container.decodeNil() {
//                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//            }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encodeNil()
//    }
//}
