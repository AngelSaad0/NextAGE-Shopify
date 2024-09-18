//
//  ProductDetailsViewModelTests.swift
//  NextAGE ShopifyTests
//
//  Created by Ahmed El Gndy on 15/09/2024.
//

import XCTest
@testable import NextAGE_Shopify



class ProductDetailsViewModelTests: XCTestCase {

    
    var viewModel: ProductDetailsViewModel! // Assuming fetchProduct belongs to this ViewModel
    
    override func setUp() {
        super.setUp()
        viewModel = ProductDetailsViewModel()
        viewModel.productID = 9426161074472
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchProduct() {
        viewModel.sizes = ["red"]
        viewModel.colors = ["red"]
        let exp = expectation(description: "Product fetched from API")
        
   
        
        viewModel.fetchProduct()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            XCTAssertNotNil(self?.viewModel.product, "Product should not be nil")
            XCTAssertEqual(self?.viewModel.product?.id, 9426161074472, "Product ID should be 1")
                        exp.fulfill()
        }
                waitForExpectations(timeout: 8) { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }

    
    func testcetchProductSuccess() {
         // Arrange
        viewModel.isFavorite = true
        viewModel.wishlist = [LineItem(id: 1, variantID: 1, productID: 1, price: "20", name: "shoe", title:"shoe" , quantity:4, properties: [NoteAttribute(name: "v", value: "v")])]
        viewModel.shoppingCart = [LineItem(id: 1, variantID: 1, productID: 1, price: "20", name: "shoe", title:"shoe" , quantity:4, properties: [NoteAttribute(name: "v", value: "v")])]

         // Act
        
        viewModel.addToWishlist()
        viewModel.addToShoppingCart()
        //assert
        XCTAssertEqual(viewModel.wishlist?[0].id, 1)
         
     }
    func testaddToWishlist_ifFavoriteFalse() {
         // Arrange
        viewModel.isFavorite = false
        viewModel.addToWishlist()
       
        //assert
        
         
        XCTAssertNotNil(viewModel.isFavorite)
     }
    func testaddToWishlist_whenit_emty() {
         // Arrange
        viewModel.isFavorite = true
        viewModel.wishlist = []
        viewModel.addToWishlist()


         
     }
    func testaddToWishlist_variantIDNotNill() {
         // Arrange
        viewModel.isFavorite = true
        viewModel.wishlist = [LineItem(id: 1, variantID: 1, productID: 1, price: "20", name: "shoe", title:"shoe" , quantity:4, properties: [NoteAttribute(name: "v", value: "v")])]
        viewModel.addToWishlist()


         
     }
    func testselectedVariantID() {
         // Arrange
        viewModel.isFavorite = true
        viewModel.wishlist = [LineItem(id: 1, variantID: 1, productID: 1, price: "20", name: "shoe", title:"shoe" , quantity:4, properties: [NoteAttribute(name: "v", value: "v")])]
        viewModel.shoppingCart = [LineItem(id: 1, variantID: 1, productID: 1, price: "20", name: "shoe", title:"shoe" , quantity:4, properties: [NoteAttribute(name: "v", value: "v")])]

         // Act
        
        viewModel.addToWishlist()
        viewModel.addToShoppingCart()


         
     }



}
