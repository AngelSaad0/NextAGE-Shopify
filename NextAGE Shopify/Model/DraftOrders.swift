//
//  DraftOrders.swift
//  NextAGE Shopify
//
//  Created by Ahmed El gndy on 06/09/2024.
//

import Foundation


// MARK: - DraftOrders
struct DraftOrders: Codable {
    let draftOrders: [DraftOrder]

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_orders"
    }
}

// MARK: - DraftOrderWrapper
struct DraftOrderWrapper: Codable {
    let draftOrder: DraftOrder

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

// MARK: - DraftOrder
struct DraftOrder: Codable {
    let id: Int
    let name: String
    let customer: CustomerInfo?
//    let shippingAddress, billingAddress: Address?
    let note: String?
    let noteAttributes: [NoteAttribute]
    let email, currency: String?
    let lineItems: [LineItem]
    let paymentTerms: PaymentTerms?
    let appliedDiscount: AppliedDiscount?
    let subtotalPrice, totalPrice: String
    let updatedAt :String
    let status: String

    enum CodingKeys: String, CodingKey {
        case id
        case name, customer
//        case shippingAddress = "shipping_address"
//        case billingAddress = "billing_address"
        case note
        case noteAttributes = "note_attributes"
        case email, currency
        case lineItems = "line_items"
        case paymentTerms = "payment_terms"
        case appliedDiscount = "applied_discount"
        case subtotalPrice = "subtotal_price"
        case totalPrice = "total_price"
        case status
        case updatedAt = "updated_at"
    }
}

// MARK: - AppliedDiscount
struct AppliedDiscount: Codable {
    let title, description, value, valueType: String
    let amount: String

    enum CodingKeys: String, CodingKey {
        case title, description, value
        case valueType = "value_type"
        case amount
    }
}


// MARK: - NoteAttribute
struct NoteAttribute: Codable {
    let name, value: String
}

// MARK: - PaymentTerms
struct PaymentTerms: Codable {
    let amount: Int
    let currency, paymentTermsName, paymentTermsType: String
    let dueInDays: Int
    let paymentSchedules: [PaymentSchedule]

    enum CodingKeys: String, CodingKey {
        case amount, currency
        case paymentTermsName = "payment_terms_name"
        case paymentTermsType = "payment_terms_type"
        case dueInDays = "due_in_days"
        case paymentSchedules = "payment_schedules"
    }
}

// MARK: - PaymentSchedule
struct PaymentSchedule: Codable {
    let amount: Int
    let currency: String
    let issuedAt, dueAt: Date
    let completedAt, expectedPaymentMethod: String

    enum CodingKeys: String, CodingKey {
        case amount, currency
        case issuedAt = "issued_at"
        case dueAt = "due_at"
        case completedAt = "completed_at"
        case expectedPaymentMethod = "expected_payment_method"
    }
}
