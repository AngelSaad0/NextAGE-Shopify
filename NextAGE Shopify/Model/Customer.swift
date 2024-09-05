//
//  Customer.swift
//  NextAGE Shopify
//
//  Created by Ahmed El Gndy on 9/6/24.
//
import Foundation
// MARK: - Customers
struct Customers: Codable {
    let customers: [Customer]
}

// MARK: - Customer
struct Customer: Codable {
    let id: Int
    let email: String
    let createdAt, updatedAt: Date
    let firstName, lastName: String?
    let ordersCount: Int
    let state: CustomerState
    let totalSpent: String
    let lastOrderID: Int?
    let note: String?
    let verifiedEmail: Bool
    let multipassIdentifier: String?
    let taxExempt: Bool
    let tags: String
    let lastOrderName: String?
    let currency: Currency
    let phone: String?
    let addresses: [Address]
    let acceptsMarketing: Bool
    let acceptsMarketingUpdatedAt: String?
    let marketingOptInLevel: OptInLevel
    let taxExemptions: [String]
    let emailMarketingConsent: MarketingConsent
    let smsMarketingConsent: MarketingConsent?
    let adminGraphqlAPIID: String
    let defaultAddress: Address?

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderID = "last_order_id"
        case note
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency, phone, addresses
        case acceptsMarketing = "accepts_marketing"
        case acceptsMarketingUpdatedAt = "accepts_marketing_updated_at"
        case marketingOptInLevel = "marketing_opt_in_level"
        case taxExemptions = "tax_exemptions"
        case emailMarketingConsent = "email_marketing_consent"
        case smsMarketingConsent = "sms_marketing_consent"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case defaultAddress = "default_address"
    }
}

// MARK: - Address
struct Address: Codable {
    let id, customerID: Int
    let firstName, lastName: String
    let company: Company?
    let address1: String
    let address2: Address2?
    let city: String
    let province: Province?
    let country, zip, phone, name: String
    let provinceCode: ProvinceCode?
    let countryCode, countryName: String
    let addressDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case company, address1, address2, city, province, country, zip, phone, name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case addressDefault = "default"
    }
}

enum Address2: String, Codable {
    case egypt = "Egypt"
}

enum Company: String, Codable {
    case fancyCo = "Fancy Co."
}

enum Province: String, Codable {
    case ontario = "Ontario"
    case quebec = "Quebec"
}

enum ProvinceCode: String, Codable {
    case on = "ON"
    case qc = "QC"
}

enum Currency: String, Codable {
    case egp = "EGP"
}

// MARK: - MarketingConsent
struct MarketingConsent: Codable {
    let state: EmailMarketingConsentState
    let optInLevel: OptInLevel
    let consentUpdatedAt: String?
    let consentCollectedFrom: ConsentCollectedFrom?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
        case consentCollectedFrom = "consent_collected_from"
    }
}

enum ConsentCollectedFrom: String, Codable {
    case other = "OTHER"
}

enum OptInLevel: String, Codable {
    case singleOptIn = "single_opt_in"
}

enum EmailMarketingConsentState: String, Codable {
    case notSubscribed = "not_subscribed"
}

enum CustomerState: String, Codable {
    case disabled = "disabled"
    case enabled = "enabled"
}
