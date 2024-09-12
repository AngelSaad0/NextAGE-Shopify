//
//  VaildMassage.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/6/24.
//


import Foundation
public enum VaildMassage: String {
   case none = ""
   case nameEmpty = "name is empty"
   case nameVaild =  "name not vaild"
   case emailEmpty = "email empty"
   case emailValid = "email not vaild"
   case passwordEmpty = "password is empty"
   case passwordVaild = "password not vaild"
   case reTypeEmpty = "reType password is empty"
   case reTypeVaild = "reType password not vaild"
   case passwordRetypeEqual = "passwoed not equal"
   case mobileVaild = "mobile not vaild"
   case mobileEmpty = "mobile is empty"
   case termsConditions = "agree for term and conditions"
   case successLogin = "LoggedIn Successfully"
   case successRegister = "Registered Successfully"

   case checkingEmailFail = "Error checking if email not already registered"
   case emailExist = "Entered email already exists"
   case encodingFail = "Error encoding customer info"
   case customerCreationFail = "Failed to create new customer"
   case draftsCreationFail = "Failed to create ShoppingCart or Wishlist"
    
   case emailDoesNotExist = "Entered email does not exist"
   case passwordDoesNotMatch = "You have entered wrong password"
    
   case addedToWishlist = "Item successfully added to wishlist"
   case removedFromWishlist = "Item successfully removed from wishlist"
   case addedToShoppingCart = "Item successfully added to shopping cart"
   case removedFromShoppingCart = "Item successfully removed from shopping cart"
    
   case ordersFetchingFailed = "Error happened while loading your orders"
    
   case addressesFetchingFailed = "Error happened while loading your addresses"
   case newSelectedAddressFailed = "Error happened while updating your default address"
   case defaultAddressUpdated = "Default address updated successfully"
   case newAddressAdded = "New address added successfully"

   case discountCodeEmpty = "You have not entered a discount code"
   case discountCodeFailed = "Entered discount code is not valid"
   case discountCodeApplied = "Congratulations, discount code applied"
    
   case placingOrderFailed = "Error happened while sending your order"

   case emptyOrderArray = "No order found"

}

