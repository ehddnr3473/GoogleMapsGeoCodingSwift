//
//  GeoCodingResponse.swift
//  
//
//  Created by 김동욱 on 2023/03/16.
//

import Foundation

public struct GeoCodingResponse: Decodable {
    public let results: [Result]
    public let status: String
    
    // MARK: - Result
    public struct Result: Codable {
        public let addressComponents: [AddressComponent]
        public let formattedAddress: String
        public let geometry: Geometry
        public let placeID: String
        public let plusCode: PlusCode
        public let types: [String]
        
        enum CodingKeys: String, CodingKey {
            case addressComponents = "address_components"
            case formattedAddress = "formatted_address"
            case geometry
            case placeID = "place_id"
            case plusCode = "plus_code"
            case types
        }
    }
    
    // MARK: - AddressComponent
    public struct AddressComponent: Codable {
        public let longName, shortName: String
        public let types: [String]
        
        enum CodingKeys: String, CodingKey {
            case longName = "long_name"
            case shortName = "short_name"
            case types
        }
    }
    
    // MARK: - Geometry
    public struct Geometry: Codable {
        public let location: Location
        public let locationType: String
        public let viewport: Viewport
        
        enum CodingKeys: String, CodingKey {
            case location
            case locationType = "location_type"
            case viewport
        }
    }
    
    // MARK: - Location
    public struct Location: Codable {
        public let lat, lng: Double
    }
    
    // MARK: - Viewport
    public struct Viewport: Codable {
        public let northeast, southwest: Location
    }
    
    public struct PlusCode: Codable {
        public let compoundCode, globalCode: String
        
        enum CodingKeys: String, CodingKey {
            case compoundCode = "compound_code"
            case globalCode = "global_code"
        }
    }
}
