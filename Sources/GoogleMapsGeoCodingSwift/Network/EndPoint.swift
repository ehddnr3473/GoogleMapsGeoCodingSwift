//
//  EndPoint.swift
//  
//
//  Created by 김동욱 on 2023/03/16.
//

import Foundation

enum HttpMethodType: String {
    case get = "GET"
}

enum OutputFormat: String {
    case json = "json"
}

public enum EndPoint {
    case `default`
}

extension EndPoint {
    var baseURL: String {
        switch self {
        case .`default`:
            return "https://maps.googleapis.com"
        }
    }
    
    var path: String {
        switch self {
        case .`default`:
            return "/maps/api/geocode/\(OutputFormat.json.rawValue)?"
        }
    }
    
    var method: String {
        switch self {
        case .`default`:
            return HttpMethodType.get.rawValue
        }
    }
}
