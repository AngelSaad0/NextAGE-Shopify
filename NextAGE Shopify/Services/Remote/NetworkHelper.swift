//
//  NetworkHelper.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
}

 
enum HTTPMethodType {
    case get
    case post
    case put
    case delete
}
 
enum NetworkErrorType: Error {
    case internalError
    case serverError
    case parsingError
    case badURL
}
struct EmptyResponse: Codable {}

