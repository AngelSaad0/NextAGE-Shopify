//
//  HomeTests.swift
//  NextAGE ShopifyTests
//
//  Created by Engy on 14/09/2024.
//

import XCTest
@testable import NextAGE_Shopify

final class HomeTests: XCTestCase {
    var viewModel: HomeViewModel!

    override func setUpWithError() throws {
        viewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
  
      
      func testLoadBrands() {
          let expectation = self.expectation(description: "Brands should be loaded")
          
          viewModel.loadBrands {
              XCTAssertFalse(self.viewModel.brandsResultArray.isEmpty, "Brands should not be empty")
              expectation.fulfill()
          }
          
          waitForExpectations(timeout: 10.0, handler: nil)
      }
      
      func testLoadPriceRules() {
          let expectation = self.expectation(description: "Price rules should be loaded")
          
          viewModel.loadPriceRules {
              XCTAssertFalse(self.viewModel.discountCodes.isEmpty, "Discount codes should not be empty")
              expectation.fulfill()
          }
          
          waitForExpectations(timeout: 10.0, handler: nil)
      }
  }
