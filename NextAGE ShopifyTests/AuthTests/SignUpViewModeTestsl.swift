//
//  SignUpViewModel.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 14/09/2024.
//

import XCTest
@testable import NextAGE_Shopify
final class SignUpViewModelTess: XCTestCase {
    var viewModel: SignUpViewModel!

    override func setUpWithError() throws {
        viewModel = SignUpViewModel()
         viewModel.firstName = "John"
         viewModel.lastName = "Doe"
         viewModel.email = "testuser@example.com"
         viewModel.password = "password123"
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }



}
