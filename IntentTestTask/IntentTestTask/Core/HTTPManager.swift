//
//  HTTPManager.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

protocol URLSessionProtocol {
    associatedtype DataTaskProtocolType: URLSessionDataTaskProtocol
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskProtocolType
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskProtocolType
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

protocol HTTPManagerProtocol {
    associatedtype T
    var session: T { get }
    init(session: T)
    
    func perform(request: URLRequest, onComplete: @escaping (Result<Data, IntentTestTaskError>) -> Void)
}

class HTTPManager<T: URLSessionProtocol> {
    
    let session: T

    required init(session: T) {
        self.session = session
    }
    
    public func perform(request: URLRequest, onComplete: @escaping (Result<Data, IntentTestTaskError>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                onComplete(.failure(.custom(error: error)))
                return
            }
            
            if let statusCode = response?.statCode, (200..<300).contains(statusCode) {
                onComplete(.failure(.badStatusCode(value: statusCode)))
                return
            }

            guard let data = data else {
                onComplete(.failure(.corruptedData))
                return
            }
            
            onComplete(.success(data))
        }.resume()
    }
}

extension HTTPManager : HTTPManagerProtocol {}

extension URLSession: URLSessionProtocol {}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension Range {
    func contains(_ value: Self.Bound?) -> Bool {
        guard let value = value else { return false }
        return contains(value)
    }
}
