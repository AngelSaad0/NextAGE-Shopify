//
//  CategoriesAndBrandTests.swift
//  NextAGE ShopifyTests
//
//  Created by Engy on 14/09/2024.
//

import XCTest
@testable import NextAGE_Shopify

final class CategoriesAndBrandTests: XCTestCase {
    var viewModel: CategoriesAndBrandsViewModel!

    override func setUpWithError() throws {
        viewModel = CategoriesAndBrandsViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil    }
    
    func testFilterResults_WithValidCategory() {
        viewModel.productResults = [
            Product(id: 1, title: "Product 1", bodyHTML: "", vendor: "", productType: .shoes, createdAt: "", handle: "", updatedAt: "", publishedAt: "", tags: "women", status: .active, adminGraphqlAPIID: "", variants: [], options: [], images: [], image: ProductImage(id: 1, position: 1, productID: 1, createdAt: "", updatedAt: "", adminGraphqlAPIID: "", width: 100, height: 100, src: ""))

        ]
        
        viewModel.filterResults(category: "Women", subCategory: "SHOES")
        
        XCTAssertEqual(viewModel.filteredOrSortedProducts.count, 1, "There should be one product filtered for 'Women' category.")
        XCTAssertEqual(viewModel.filteredOrSortedProducts.first?.title, "Product 1", "The filtered product should be 'Product 1'")
    }
    
    func testLoadProducts() {
        let expectation = self.expectation(description: "Products should be loaded")
        var hasFulfilled = false // Flag to track if the expectation has been fulfilled

        viewModel.bindResultTable = {
            if !hasFulfilled {
                XCTAssertFalse(self.viewModel.productResults.isEmpty, "Products should not be empty after loading")
                expectation.fulfill()
                hasFulfilled = true // Set the flag to true after fulfilling the expectation
            }
        }
        
        viewModel.setIndicator = { isLoading in
            XCTAssertFalse(isLoading, "Loading indicator should be off after loading products")
        }
        
        viewModel.loadProducts()
        
        waitForExpectations(timeout: 20, handler: nil)
    }

    func testSearchProducts() {
        viewModel.productResults = [
            Product(id: 1, title: "we", bodyHTML: "", vendor: "", productType: .shoes, createdAt: "", handle: "", updatedAt: "", publishedAt: "", tags: "women", status: .active, adminGraphqlAPIID: "", variants: [], options: [], images: [], image: ProductImage(id: 1, position: 1, productID: 1, createdAt: "", updatedAt: "", adminGraphqlAPIID: "", width: 100, height: 100, src: "")) // Initialized with default values

        ]
        
        viewModel.searchProducts(with: "we")
        
        XCTAssertEqual(viewModel.filteredOrSortedProducts.count, 1, "There should be one product matching the search term 'Special'")
        XCTAssertEqual(viewModel.filteredOrSortedProducts.first?.title, "we", "The filtered product should be 'Special Product'")
    }
}
