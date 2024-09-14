//
//  SignInViewModelTest.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 14/09/2024.
//

import XCTest
@testable import NextAGE_Shopify
final class SignInViewModelTest: XCTestCase {
    
    var viewModel : SignInViewModel?
    
    override func setUpWithError() throws {
        viewModel = SignInViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testValidateAndLogin() {
        let expectation = self.expectation(description: "Error should be .emailEmpty")
        viewModel?.onError = { error in
            XCTAssertEqual(error, .emailEmpty)
            expectation.fulfill()
        }
        viewModel?.validateAndLogin(email: "", password: "password123")
        waitForExpectations(timeout: 1.0, handler: nil)
    }


    func testValidateAndLogin_PasswordIsEmpty() {
        let expectation = self.expectation(description: "Error should be .passwordEmpty")
        viewModel?.onError = { error in
            XCTAssertEqual(error, .passwordEmpty)
            expectation.fulfill()
        }
        
        viewModel?.validateAndLogin(email: "validemail@example.com", password: "")

        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testValidateAndLogin_ValidCredentials() {
        let expectation = self.expectation(description: "Login should succeed")

        viewModel?.onSuccess = {
            expectation.fulfill()
        }

        viewModel?.validateAndLogin(email: "aaaaaaa@gmail.com", password: "112233!!@@##qq")

        waitForExpectations(timeout: 2, handler: nil)
    }
    
    /*
    func testCheckUserAuth_EmailDoesNotExist() {
        let expectation = self.expectation(description: "Error should be .emailDoesNotExist")
        
        viewModel?.onError = { error in
            XCTAssertEqual(error, .emailDoesNotExist)
            expectation.fulfill()
        }

       
        viewModel?.checkUserAuth(email: "nonexistentemail@example.com", password: "password123")
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testCheckUserAuth_PasswordDoesNotMatch() {
        let expectation = self.expectation(description: "Error should be .passwordDoesNotMatch")
        
        viewModel?.onError = { error in
            XCTAssertEqual(error, .passwordDoesNotMatch)
            expectation.fulfill()
        }
        viewModel?.checkUserAuth(email: "validemail@example.com", password: "wrongPassword")
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testCheckUserAuth_Success() {
        let expectation = self.expectation(description: "Login should succeed")
        viewModel?.onSuccess = {
            expectation.fulfill()
        }
        viewModel?.checkUserAuth(email: "validemail@example.com", password: "correctPassword")
        waitForExpectations(timeout: 1.0, handler: nil)
    }
     */
}
