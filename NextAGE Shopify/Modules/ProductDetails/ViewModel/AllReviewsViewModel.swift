//
//  AllReviewsViewModel.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 08/09/2024.
//

import Foundation

class AllReviewsViewModel {
    // MARK: - Public Methods
    func getReviewsCount() -> Int {
        return dummyReviews.count
    }
    
    func getReview(at index: Int) -> DumyReview {
        return dummyReviews[index]
    }
}
