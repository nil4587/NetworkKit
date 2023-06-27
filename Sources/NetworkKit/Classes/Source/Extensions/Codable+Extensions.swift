//
//  Codable+Extensions.swift
//  NetworkKit
//
//  Created by Nileshkumar M. Prajapati on 2023/06/26.
//

import Foundation

extension Decodable {
    
    public func decode<T: Decodable>(from dictionary: [String : Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public static func decode<T: Decodable>(_ data: Data) -> T? {
        do {
            let responseModel = try JSONDecoder().decode(T.self, from: data)
            return responseModel
        } catch {
        #if DEBUG
            print(self, error.localizedDescription)
        #endif
            return nil
        }
    }
}

extension Encodable {
    public static func encode<T: Encodable>(_ value: T) -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(value)
            return jsonData
        } catch {
        #if DEBUG
            print(error.localizedDescription)
        #endif
            return nil
        }
    }
    
    public static func jsonData(_ data: Data) -> [String: Any]? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any]
            return jsonObject
        } catch {
            return nil
        }
    }
}
