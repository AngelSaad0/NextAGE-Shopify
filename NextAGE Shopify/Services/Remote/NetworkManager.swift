//
//  NetworkManager.swift
//  NextAGE Shopify
//
//  Created by Mohamed Ayman on 03/09/2024.
//

import Foundation
import Alamofire
protocol NetworkManagerProtocol {
    func fetchData<T: Codable>(from url: String, responseType: T.Type, headers: HTTPHeaders, completion: @escaping (T?) -> Void)
    func postData<T: Codable>(to url: String, responseType: T.Type, parameters: Parameters, completion: @escaping (T?) -> Void)
    func postWithoutResponse(to url: String, parameters: Parameters)
    func updateData(at url: String, with parameters: Parameters, completion: @escaping () -> ())
    func deleteData(at url: String, completion: @escaping ()->())
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()

    private let defaultHeaders: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]

    private func makeRequest<T: Codable>(url: String, method: HTTPMethod, parameters: Parameters? = nil, responseType: T.Type, headers: HTTPHeaders = [:], completion: @escaping (Result<T, Error>) -> Void) {
        guard let requestURL = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
//        let finalHeaders = headers.isEmpty ? defaultHeaders : headers
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

    func updateData(at url: String, with parameters: Parameters, completion: @escaping () -> ()) {
        makeRequest(url: url, method: .put, parameters: parameters, responseType: EmptyResponse.self) { _ in
            completion()
        }
    }

    func deleteData(at url: String, completion: @escaping ()->()) {
        makeRequest(url: url, method: .delete, responseType: EmptyResponse.self) { result in
            switch result {
            case .success:
                completion()
                print("Item deleted successfully")
            case .failure(let error):
                completion()
                print("Error deleting item: \(error)")
            }
        }
    }
}
