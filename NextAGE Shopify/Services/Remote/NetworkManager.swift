//
//  NetworkManager.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import Foundation
import Alamofire
 
struct EmptyResponse: Codable {}

class NetworkManager {

    private let defaultHeaders: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Cookie": ""
    ]

    private func makeRequest<T: Codable>(url: String, method: HTTPMethod, parameters: Parameters? = nil, responseType: T.Type, headers: HTTPHeaders = [:], completion: @escaping (Result<T, Error>) -> Void) {
        guard let requestURL = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        AF.request(requestURL, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers.isEmpty ? defaultHeaders : headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(NetworkError.decodingFailed))
                    }
                case .failure(let error):
                    self.logError(error, data: response.data)
                    completion(.failure(error))
                }
            }
    }

    func fetchData<T: Codable>(from url: String, responseType: T.Type, headers: HTTPHeaders = [:], completion: @escaping (T?) -> Void) {
        makeRequest(url: url, method: .get, responseType: responseType, headers: headers) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure:
                completion(nil)
            }
        }
    }

    func postData<T: Codable>(to url: String, responseType: T.Type, parameters: Parameters, completion: @escaping (T?) -> Void) {

        makeRequest(url: url, method: .post, parameters: parameters, responseType: responseType) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure:
                completion(nil)
            }
        }
    }

    func postWithoutResponse(to url: String, parameters: Parameters) {
        makeRequest(url: url, method: .post, parameters: parameters, responseType: EmptyResponse.self) { _ in }
    }

    func updateData(at url: String, with parameters: Parameters) {
        makeRequest(url: url, method: .put, parameters: parameters, responseType: EmptyResponse.self) { _ in }
    }

    func deleteData(at url: String) {
        makeRequest(url: url, method: .delete, responseType: EmptyResponse.self) { result in
            switch result {
            case .success:
                print("Item deleted successfully")
            case .failure(let error):
                print("Error deleting item: \(error)")
            }
        }
    }

    private func logError(_ error: Error, data: Data?) {
        print("Error: \(error.localizedDescription)")
        if let responseData = data {
            print("Response Data: \(String(data: responseData, encoding: .utf8) ?? "")")
        }
    }
//    func createCustomer(firstName: String, lastName: String, email: String, phone: String, password: String, completion: @escaping (CustomerModel?) -> Void) {
//        let parameters: Parameters = [
//            "customer": [
//                "first_name": firstName,
//                "last_name": lastName,
//                "email": email,
//                "phone": phone,
//                "verified_email": true,
//                "password": password
//            ]
//        ]
//        postData(to: url, responseType: Customer.self, parameters: parameters) { response in
//            completion(response?.customer)
//        }
//    }

}
 

