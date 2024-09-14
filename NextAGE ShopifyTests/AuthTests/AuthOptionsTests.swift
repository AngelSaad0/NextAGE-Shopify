//
//  AuthTests.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 14/09/2024.
//

import XCTest
@testable import NextAGE_Shopify
final class AuthTests: XCTestCase {
    
    var  viewModel: AuthOptionsViewModel?
    override func setUpWithError() throws {
        //init
        viewModel = AuthOptionsViewModel()
    }
    

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testSkipButtonClicked() throws {
        // Arrange
          let expectation = self.expectation(description: "Root View Controller should be set")
          
          // Act
        viewModel?.setRootViewController = { rootVC, navController in
              XCTAssertEqual(rootVC, "MainTabBar")
              XCTAssertEqual(navController, "MainTabBarNavigationController")
              expectation.fulfill()
          }
          
        viewModel?.skipButtonClicked()

          // Assert
          waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testSignInButtonClicked() throws {
        // Arrange
         let expectation = self.expectation(description: "Should navigate to SignInViewController")
         
         // Act
        viewModel?.navigateToViewController = { viewControllerName in
             XCTAssertEqual(viewControllerName, "SignInViewController")
             expectation.fulfill()
         }
         
        viewModel?.signInButtonClicked()

         // Assert
         waitForExpectations(timeout: 1.0, handler: nil)
    }
    func testSignUpButtonClicked_triggersNavigateToViewControllerClosure() {
        // Arrange
              let expectation = self.expectation(description: "Should navigate to SignUpViewController")
              
              // Act
        viewModel?.navigateToViewController = { viewControllerName in
                  XCTAssertEqual(viewControllerName, "SignUpViewController")
                  expectation.fulfill()
              }
              
        viewModel?.signUpButtonClicked()

              // Assert
              waitForExpectations(timeout: 1.0, handler: nil)
     }

    func testCheckConnectivity_whenConnected_returnsTrue() {
        let expectation = self.expectation(description: "Completion handler called For concitivty ")
        var connectivityResult: Bool = false
        
        viewModel?.checkConnectivity { isConnected in
            connectivityResult = isConnected
            expectation.fulfill()
        }
                waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(connectivityResult, "Expected true but got \(connectivityResult)")
    }

}
