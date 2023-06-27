//
//  Configurations.swift
//  NetworkKit
//
//  Created by Nileshkumar M. Prajapati on 2023/06/26.
//

import Foundation

struct Configurations {
    
    struct Request {
        static let REQUEST_TIMEOUT: Double = 60
    }
    
    /// A structure which keeps web-service request's keys
    struct RequestHeaderKey {
        static let ContentType_Key = "Content-Type"
        static let ContentType_Value = "application/json"
        static let Cache_Control_Key = "Cache-Control"
        static let Cache_Control_Value = "no-cache"
    }
}

// MARK: - ================================
// MARK: HTTPURLResponse
// MARK: ================================

extension HTTPURLResponse {
    var type: HTTPResponseType? {
        return HTTPResponseCode(rawValue: statusCode)?.responseType
    }
    
    var code: HTTPResponseCode {
        return HTTPResponseCode(rawValue: statusCode) ?? .Unknown
    }
}
