//
//  WebServiceManager.swift
//  NetworkKit
//
//  Created by Nileshkumar M. Prajapati on 2023/06/26.
//

import Foundation

public struct Resource<T> {
    let url: URL
    let method: HttpMethod
    let body: Data?
    let parse: (Data) -> T?
    
    public init(url: URL, method: HttpMethod, body: Data?, parse: @escaping (Data) -> T?) {
        self.url = url
        self.method = method
        self.body = body
        self.parse = parse
    }
}

final public class WebServiceManager: NSObject {
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Properties Declaration
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    public static let webServiceHelper = WebServiceManager()
    private var urlSession: URLSession {
        let config = URLSessionConfiguration.default
        config.multipathServiceType = .handover
        config.timeoutIntervalForRequest = TimeInterval(timeOutInterval)
        config.timeoutIntervalForResource = TimeInterval(timeOutInterval)
        return URLSession(configuration: config)
    }
    private let timeOutInterval: Double = Configurations.Request.REQUEST_TIMEOUT
    private var task: URLSessionTask?
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: User-defined Methods
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    private override init() {}
    
    func stopTask() {
        if task?.state == .running {
            task?.cancel()
        }
    }
    
    // A method to handle multiple web-service calls with completion handler
    public func fetchData<T>(resource: Resource<T>,
                      completionHandler: @escaping (Result<T?, Error>) -> Void) {
        
        if task?.state == .running {
            task?.cancel()
        }
        
        var request = URLRequest(url: resource.url)
        request.httpBody = resource.body
        request.httpMethod = resource.method.rawValue
        request.allHTTPHeaderFields = [Configurations.RequestHeaderKey.ContentType_Key: Configurations.RequestHeaderKey.ContentType_Value,
                                       Configurations.RequestHeaderKey.Cache_Control_Key : Configurations.RequestHeaderKey.Cache_Control_Value]
        
        task = urlSession.dataTask(with: request) { (data, response, error) in
            let httpresponse = response as? HTTPURLResponse
            if httpresponse?.type == .success, let respondata = data {
                #if DEBUG
                    let string = String(data: respondata, encoding: .utf8)
                    print(string as Any)
                #endif
                completionHandler(.success(resource.parse(respondata)))
            } else {
                if let errr = error {
                    completionHandler(.failure(errr))
                } else {
                    guard let statuscode = httpresponse?.code,
                            let type = httpresponse?.type else { return }

                    #if DEBUG
                        print(HTTPURLResponse.localizedString(forStatusCode: statuscode.rawValue))
                    #endif
                    completionHandler(.failure(type))
                }
            }
        }
        task?.resume()
    }
    
    // A method to handle multiple web-service calls with async await
    @available(iOS 15.0, *)
    public func fetchData<T>(resource: Resource<T>) async -> Result<T?, NetworkKitError> {

        var request = URLRequest(url: resource.url)
        request.httpBody = resource.body
        request.httpMethod = resource.method.rawValue
        request.allHTTPHeaderFields = [Configurations.RequestHeaderKey.ContentType_Key: Configurations.RequestHeaderKey.ContentType_Value,
                                       Configurations.RequestHeaderKey.Cache_Control_Key : Configurations.RequestHeaderKey.Cache_Control_Value]
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpresponse = response as? HTTPURLResponse else {
                return .failure(.noresponse)
            }
            
            if httpresponse.type == .success {
                #if DEBUG
                    let string = String(data: data, encoding: .utf8)
                    print(string as Any)
                #endif
                return .success(resource.parse(data))
            } else {
                return .failure(.nodata)
            }
        } catch {
            return .failure(.urlfailure)
        }
    }
}

// MARK: - ================================
// MARK: URLSession Delegate Methods
// MARK: ================================

extension WebServiceManager: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(error?.localizedDescription as Any)
    }
    
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    }
}

