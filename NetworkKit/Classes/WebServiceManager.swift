//
//  WebServiceManager.swift
//  NetworkKit
//
//  Created by Nileshkumar M. Prajapati on 2023/06/26.
//

import Foundation

struct Resource<T> {
    let url: URL
    let method: HttpMethod
    let body: Data?
    let parse: (Data) -> T?
}

final class WebServiceManager: NSObject {
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Properties Declaration
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    static let webServiceHelper = WebServiceManager()
    private var urlSession: URLSession {
        let config = URLSessionConfiguration.default
        config.multipathServiceType = .handover
        config.timeoutIntervalForRequest = TimeInterval(timeOutInterval)
        config.timeoutIntervalForResource = TimeInterval(timeOutInterval)
        return URLSession(configuration: config)
    }
    private let timeOutInterval: Double = Configurations.API.REQUEST_TIMEOUT
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
    func fetchData<T>(resource: Resource<T>,
                      completionHandler: @escaping (_ status: Bool, _ error: String?, _ object: T?) -> Void) {
        
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
                completionHandler(true, nil, resource.parse(respondata))
            } else {
                if let errr = error {
                    completionHandler(false, errr.localizedDescription, nil)
                } else if let statuscode = httpresponse?.code {
                    let message = HTTPURLResponse.localizedString(forStatusCode: statuscode.rawValue)
                    completionHandler(false, message, nil)
                } else {
                    completionHandler(false, "Something went wrong", nil)
                }
            }
        }
        task?.resume()
    }
    
    // A method to handle multiple web-service calls with async await
    @available(iOS 15.0, *)
    func fetchData<T>(resource: Resource<T>) async -> (Bool, String?, T?) {

        var request = URLRequest(url: resource.url)
        request.httpBody = resource.body
        request.httpMethod = resource.method.rawValue
        request.allHTTPHeaderFields = [Configurations.RequestHeaderKey.ContentType_Key: Configurations.RequestHeaderKey.ContentType_Value,
                                       Configurations.RequestHeaderKey.Cache_Control_Key : Configurations.RequestHeaderKey.Cache_Control_Value]
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpresponse = response as? HTTPURLResponse else {
                return (false, "Something went wrong", nil)
            }
            
            if httpresponse.type == .success {
                #if DEBUG
                    let string = String(data: data, encoding: .utf8)
                    print(string as Any)
                #endif
                return (true, nil, resource.parse(data))
            } else {
                let message = HTTPURLResponse.localizedString(forStatusCode: httpresponse.code.rawValue)
                return (false, message, nil)
            }
            
        } catch {
            return (false, "Something went wrong", nil)
        }
    }
}

// MARK: - ================================
// MARK: URLSession Delegate Methods
// MARK: ================================

extension WebServiceManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print(error?.localizedDescription as Any)
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    }
}

