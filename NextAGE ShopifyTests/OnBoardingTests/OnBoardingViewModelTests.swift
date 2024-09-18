//
//  OnBoardingViewModelTests.swift
//  NextAGE ShopifyTests
//
//  Created by Engy on 17/09/2024.
//

import XCTest
@testable import NextAGE_Shopify

final class OnBoardingViewModelTests: XCTestCase {
    var viewModel: OnboardingViewModel!

    override func setUpWithError() throws {
        viewModel = OnboardingViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil

    }

    func testPagesArray() throws {
        XCTAssertEqual(viewModel.pages.count, 3, "Pages array should contain 3 items.")
        
        let firstPage = viewModel.pages[0]
        XCTAssertEqual(firstPage.animationName, "animation1", "The first page's animationName should be 'animation1'.")
        XCTAssertEqual(firstPage.title, "Brand Deals", "The first page's title should be 'Brand Deals'.")
        XCTAssertEqual(firstPage.description, "Explore real-time offers from your favorite brands with customizable filters", "The first page's description is incorrect.")
    }

    func testSaveToUserDefaults() throws {
        UserDefaultsManager.shared.isBoarding = false
        viewModel.saveToUserDefaults()
        XCTAssertTrue(UserDefaultsManager.shared.isBoarding, "isBoarding should be true after calling saveToUserDefaults.")
    }

}
