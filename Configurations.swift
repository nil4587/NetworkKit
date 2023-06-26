//
//  Configurations.swift
//  NetworkKit
//
//  Created by Nileshkumar M. Prajapati on 2023/06/26.
//

import Foundation

struct Configurations {
    
    struct API {
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
// MARK: Network Operation Enums
// MARK: ================================

enum HttpMethod: String, Codable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum HTTPResponseType {
    /// - informational: This class of status code indicates a provisional response, consisting only of the Status-Line and optional headers, and is terminated by an empty line.
    case informational
    /// - success: This class of status codes indicates the action requested by the client was received, understood, accepted, and processed successfully.
    case success
    /// - redirection: This class of status code indicates the client must take additional action to complete the request.
    case redirection
    /// - clientError: This class of status code is intended for situations in which the client seems to have erred.
    case clientError
    /// - serverError: This class of status code indicates the server failed to fulfill an apparently valid request.
    case serverError
    /// - undefined: The class of the status code cannot be resolved.
    case undefined
}

enum HTTPResponseCode: Int, Error {
    
    // 100 Informational
    case Continue = 100
    case SwitchingProtocols
    case Processing
    // 200 Success
    case OK = 200
    case Created
    case Accepted
    case NonAuthoritativeInformation
    case NoContent
    case ResetContent
    case PartialContent
    case MultiStatus
    case AlreadyReported
    case IMUsed = 226
    // 300 Redirection
    case MultipleChoices = 300
    case MovedPermanently
    case Found
    case SeeOther
    case NotModified
    case UseProxy
    case SwitchProxy
    case TemporaryRedirect
    case PermanentRedirect
    // 400 Client Error
    case BadRequest = 400
    case Unauthorized
    case PaymentRequired
    case Forbidden
    case NotFound
    case MethodNotAllowed
    case NotAcceptable
    case ProxyAuthenticationRequired
    case RequestTimeout
    case Conflict
    case Gone
    case LengthRequired
    case PreconditionFailed
    case PayloadTooLarge
    case URITooLong
    case UnsupportedMediaType
    case RangeNotSatisfiable
    case ExpectationFailed
    case ImATeapot
    case MisdirectedRequest = 421
    case UnprocessableEntity
    case Locked
    case FailedDependency
    case UpgradeRequired = 426
    case PreconditionRequired = 428
    case TooManyRequests
    case RequestHeaderFieldsTooLarge = 431
    case UnavailableForLegalReasons = 451
    // 500 Server Error
    case InternalServerError = 500
    case NotImplemented
    case BadGateway
    case ServiceUnavailable
    case GatewayTimeout
    case HTTPVersionNotSupported
    case VariantAlsoNegotiates
    case InsufficientStorage
    case LoopDetected
    case NotExtended = 510
    case NetworkAuthenticationRequired
    case Unknown = -1

    /// The class (or group) which the status code belongs to.
    var responseType: HTTPResponseType {
        
        switch self.rawValue {
                
            case 100..<200:
                return .informational
                
            case 200..<300:
                return .success
                
            case 300..<400:
                return .redirection
                
            case 400..<500:
                return .clientError
                
            case 500..<600:
                return .serverError
                
            default:
                return .undefined
                
        }
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
