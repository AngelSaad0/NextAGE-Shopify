//
//  SignUpViewModelTests.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 14/09/2024.
//

import XCTest
@testable import NextAGE_Shopify
final class SignUpViewModelTests: XCTestCase {
    var viewModel: SignUpViewModel!

    override func setUpWithError() throws {
        viewModel = SignUpViewModel()
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        viewModel.email = "testuserr@example.com"
        viewModel.password = "password123"
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testCreateNewCustomer() {
        let expectation = self.expectation(description: "Customer creation should succeed")

        viewModel.navigateToHome = {
            expectation.fulfill()
        }

        viewModel.displayMessage = { message, _ in
            XCTFail("Customer creation failed with message: \(message)")
        }

        viewModel.createNewCustomer()

        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCreateNewCustomer_EmailAlreadyExists() {
        let expectation = self.expectation(description: "Customer creation should fail due to existing email")

        viewModel.navigateToHome = {
            XCTFail("Customer creation should not succeed when email already exists")
        }

        viewModel.displayMessage = { message, _ in
            if message == .emailExist {
                expectation.fulfill()
            } else {
                XCTFail("Unexpected error message: \(message)")
            }
        }

        viewModel.email = "aaaaaaa@gmail.com"
        viewModel.createNewCustomer()
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
