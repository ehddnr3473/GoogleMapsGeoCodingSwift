//
//  GeoCodingRequest.swift
//  
//
//  Created by 김동욱 on 2023/03/17.
//

import Foundation

public struct GeoCodingRequest: Encodable {
    public let address: String
    
    public init(address: String) {
        self.address = address
    }
}
