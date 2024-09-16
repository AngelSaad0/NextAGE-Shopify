//
//  DummyData.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 15/09/2024.
//

import Foundation
@testable import NextAGE_Shopify

/*struct Products: Codable {
    let products: [Product]
}*/


// Sample ProductImage
class DummyData {
    static let dummyProductImage = ProductImage(
        id: 1,
        position: 1,
        productID: 1,
        createdAt: "2024-09-15T00:00:00Z",
        updatedAt: "2024-09-15T00:00:00Z",
        adminGraphqlAPIID: "gid://shopify/ProductImage/1",
        width: 800,
        height: 600,
        src: "https://example.com/image1.jpg"
    )
    
    static let dummyOption = Option(
        id: 1,
        productID: 1,
        name: .color,
        position: 1,
        values: ["Red", "Blue", "Green"]
    )
    
    static let dummyVariant = Variant(
        id: 1,
        productID: 1,
        title: "Default Variant",
        price: "29.99",
        position: 1,
        inventoryPolicy: .deny,
        compareAtPrice: "39.99",
        option1: "Red",
        option2: "Size M",
        createdAt: "2024-09-15T00:00:00Z",
        updatedAt: "2024-09-15T00:00:00Z",
        taxable: true,
        fulfillmentService: .manual,
        grams: 500,
        inventoryManagement: .shopify,
        requiresShipping: true,
        sku: "SKU123",
        weight: 4,
        weightUnit: "kg",
        inventoryItemID: 123456,
        inventoryQuantity: 100,
        oldInventoryQuantity: 120,
        adminGraphqlAPIID: "gid://shopify/ProductVariant/1"
    )
    
    static let dummyProduct = Product(
        id: 1,
        title: "Sample Product",
        bodyHTML: "<p>This is a detailed description of the sample product.</p>",
        vendor: "Sample Vendor",
        productType: .tShirts,
        createdAt: "2024-09-15T00:00:00Z",
        handle: "sample-product",
        updatedAt: "2024-09-15T00:00:00Z",
        publishedAt: "2024-09-15T00:00:00Z",
        tags: "sample, tshirt, test",
        status: .active,
        adminGraphqlAPIID: "gid://shopify/Product/1",
        variants: [dummyVariant],
        options: [dummyOption],
        images: [dummyProductImage],
        image: dummyProductImage
    )
    
    // Sample ProductWrapper
    static let dummyProductWrapper = ProductWrapper(product: dummyProduct)
    
    // Sample Products
    static let dummyProducts = Products(products: [dummyProduct , dummyProduct])
    
}
