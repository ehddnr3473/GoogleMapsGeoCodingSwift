//
//  GeoCodingNetworkService.swift
//  
//
//  Created by 김동욱 on 2023/03/16.
//

import Foundation

public protocol GeoCodingNetworkService {
    typealias CompletionHandler = (Result<Data, Error>) -> Void
    func sendCompletion(with geoCodingRequest: GeoCodingRequest, _ endPoint: EndPoint, completionHandler: @escaping CompletionHandler)
}

public struct DefaultGeoCodingNetworkService {
    // MARK: - Private
    private let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    private func prepareRequest(geoCodingRequest: GeoCodingRequest, endPoint: EndPoint) -> URLRequest {
        var urlComponents = URLComponents()
        let address = URLQueryItem(name: "address", value: geoCodingRequest.address)
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
    public func sendCompletion(with geoCodingRequest: GeoCodingRequest, _ endPoint: EndPoint, completionHandler: @escaping CompletionHandler) {
        let request = prepareRequest(geoCodingRequest: geoCodingRequest, endPoint: endPoint)
        makeRequest(request, completionHandler: completionHandler)
    }
}
