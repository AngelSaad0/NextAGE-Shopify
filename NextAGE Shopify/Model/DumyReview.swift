//
//  DumyReview.swift
//  NextAGE Shopify
//
//  Created by Engy on 9/8/24.
//

import Foundation
struct DumyReview {
    let userName:String
    let userImage:String
    let date:String
    let review:String
    let rating:String
}
let dummyReviews: [DumyReview] = [
    DumyReview(userName: "Alice Johnson", userImage: "user1.png", date: "2024-08-31", review: "Great product, highly recommend!", rating: "5"),
    DumyReview(userName: "Bob Smith", userImage: "user2.png", date: "2024-08-30", review: "Good quality but took a while to arrive.", rating: "4"),
    DumyReview(userName: "Catherine Lee", userImage: "user3.png", date: "2024-08-29", review: "Not satisfied with the color.", rating: "2"),
    DumyReview(userName: "David Williams", userImage: "user4.png", date: "2024-08-28", review: "Amazing! Exceeded my expectations.", rating: "5"),
    DumyReview(userName: "Ella Brown", userImage: "user5.png", date: "2024-08-27", review: "Decent product for the price.", rating: "3"),
    DumyReview(userName: "Frank Green", userImage: "user6.png", date: "2024-08-26", review: "Poor customer service.", rating: "1"),
    DumyReview(userName: "Grace Hall", userImage: "user1.png", date: "2024-08-25", review: "Love it! Would buy again.", rating: "5"),
    DumyReview(userName: "Henry King", userImage: "user2.png", date: "2024-08-24", review: "Average quality.", rating: "3"),
    DumyReview(userName: "Ivy Martinez", userImage: "user3.png", date: "2024-08-23", review: "Perfect fit and great material.", rating: "5"),
    DumyReview(userName: "Jack Wilson", userImage: "user4.png", date: "2024-08-22", review: "Product was damaged upon arrival.", rating: "2"),
    DumyReview(userName: "Karen Clark", userImage: "user5.png", date: "2024-08-21", review: "Very stylish and comfortable.", rating: "4"),
    DumyReview(userName: "Leo Young", userImage: "user6.png", date: "2024-08-20", review: "Terrible experience. Not recommended.", rating: "1")
]

