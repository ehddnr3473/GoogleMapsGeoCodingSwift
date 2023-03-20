//
//  GeoCodingNetworkService.swift
//  
//
//  Created by 김동욱 on 2023/03/16.
//

import Foundation

public protocol GeoCodingNetworkService {
    typealias CompletionHandler = (Result<Data, Error>) -> Void
    
    func request(with geoCodingQuery: GeoCodingQuery, _ endPoint: EndPoint, completionHandler: @escaping CompletionHandler)
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    func request(with geoCodingQuery: GeoCodingQuery, _ endPoint: EndPoint) async throws -> Data
}

public struct DefaultGeoCodingNetworkService {
    // MARK: - Private
    private let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    private func prepareRequest(geoCodingQuery: GeoCodingQuery, endPoint: EndPoint) -> URLRequest {
        var urlComponents = URLComponents()
        let address = URLQueryItem(name: "address", value: geoCodingQuery.address)
        let key = URLQueryItem(name: "key", value: key)
        urlComponents.path = endPoint.path
        urlComponents.queryItems = [address, key]
        
        var request = URLRequest(url: urlComponents.url(relativeTo: URL(string: endPoint.baseURL))!)
        request.httpMethod = endPoint.method
        
        return request
    }
    
    private func makeRequest(_ request: URLRequest, completionHandler: @escaping CompletionHandler) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                completionHandler(.success(data))
            }
        }
        
        task.resume()
    }
}

extension DefaultGeoCodingNetworkService: GeoCodingNetworkService {
    public func request(with geoCodingQuery: GeoCodingQuery, _ endPoint: EndPoint, completionHandler: @escaping CompletionHandler) {
        let request = prepareRequest(geoCodingQuery: geoCodingQuery, endPoint: endPoint)
        makeRequest(request, completionHandler: completionHandler)
    }
    
    @available(swift 5.5)
    @available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
    public func request(with geoCodingQuery: GeoCodingQuery, _ endPoint: EndPoint) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            request(with: geoCodingQuery, endPoint) { result in
                continuation.resume(with: result)
            }
        }
    }
}
