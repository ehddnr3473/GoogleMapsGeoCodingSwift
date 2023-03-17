//
//  GeoCodingNetworkService.swift
//  
//
//  Created by 김동욱 on 2023/03/16.
//

import Foundation

public enum NetworkServiceError: String, Error {
    case responseError = "Response Error occured"
}

public protocol GeoCodingNetworkService {
    typealias CompletionHandler = (Result<Data, Error>) -> Void
}

public struct DefaultGeoCodingNetworkService {
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
    func sendCompletion(with getCodingRequest: GeoCodingRequest, _ endPoint: EndPoint, completionHandler: @escaping CompletionHandler) {
        let request = prepareRequest(geoCodingRequest: getCodingRequest, endPoint: endPoint)
        makeRequest(request, completionHandler: completionHandler)
    }
}
