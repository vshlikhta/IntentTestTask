//
//  HTTPManager.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

protocol URLSessionProtocol {
    associatedtype dataTaskProtocolType: URLSessionDataTaskProtocol
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> dataTaskProtocolType
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> dataTaskProtocolType
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol HTTPManagerProtocol {
    associatedtype T
    var session: T { get }
    init(session: T)
    
    func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void)
}

class HTTPManager<T: URLSessionProtocol> {
    
    let session: T

    required init(session: T) {
        self.session = session
    }
    
    enum HTTPError: Error {
        case invalidURL
        case noInternet
        case invalidResponse(Data?, URLResponse?)
    }
    
    public func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 60)

        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }

            guard
                let _ = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    if let data = data {
                        completionBlock(.success(data))
                    } else {
                        completionBlock(.failure(HTTPError.invalidResponse(data, response)))
                    }
                    return
            }
            if let data = data {
                completionBlock(.success(data))
            }
        }
        task.resume()
    }
}

extension HTTPManager : HTTPManagerProtocol {}

extension URLSession: URLSessionProtocol {}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
