//
//  OnboardingViewModel.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/16/24.
//

import Foundation
class OnboardingViewModel {
    // MARK: - Properties
    let pages: [Page] = [
        Page(animationName: "animation1", title: "Brand Deals", description: "Explore real-time offers from your favorite brands with customizable filters"),
        Page(animationName: "animation2", title: "Category Finder", description: "Navigate through products with smart recommendations based on categories and trends"),
        Page(animationName: "animation3", title: "Variant Offers", description: "Find exclusive deals on specific product variants with advanced search and comparison options"),
    ]
    
    // MARK: - Public Methods
    func saveToUserDefaults () {
        UserDefaultsManager.shared.isBoarding = true
        UserDefaultsManager.shared.storeData()
    }
    
}
