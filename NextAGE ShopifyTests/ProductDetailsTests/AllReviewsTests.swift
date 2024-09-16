//
//  AllReviewsTests.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 16/09/2024.
//

import XCTest
@testable import NextAGE_Shopify

final class AllReviewsTests: XCTestCase {
    var reviews : AllReviewsViewModel?
    override func setUpWithError() throws {
        reviews = AllReviewsViewModel()
        
    }

    override func tearDownWithError() throws {
        reviews = nil
    }

    func testExample() throws {
        //act
        reviews?.getReview(at: 1)
      let count =   reviews?.getReviewsCount()
     //assert
        XCTAssertEqual(count,12)
      
    }

}
