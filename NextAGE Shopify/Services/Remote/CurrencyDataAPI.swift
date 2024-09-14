//
//  CurrencyData.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 14/09/2024.
//

import Foundation
import Alamofire

enum CurrencyDataAPI {
    private static let apiKey = "dg91Qb1Qx2Lu6sV68KNWhCrPfRIT81OD"
    private static let ssl = "https://"
    private static let baseURL = "api.apilayer.com"
    static let header: HTTPHeaders = ["apikey": apiKey]
    
    case exchange(to: String, from: String = "USD")
    
    private var path: String {
        switch self {
            
        case .exchange(let to, let from):
            return "currency_data/convert?to=\(to)&from=\(from)&amount=1"
        }
    }

    func URLString() -> String {
        return "\(CurrencyDataAPI.ssl)\(CurrencyDataAPI.baseURL)/\(path)"
    }

}
