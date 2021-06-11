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
    
    func get(request: URLRequest, onComplete: @escaping (Result<Data, Error>) -> Void)
}

class HTTPManager<T: URLSessionProtocol> {
    
    let session: T

    required init(session: T) {
        self.session = session
    }
    
    public func get(request: URLRequest, onComplete: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                onComplete(.failure(error))
                return
            }
            
            guard (200..<300).contains(response?.statCode) else {
                onComplete(.failure(IntentTestTaskError.badStatusCode))
                return
            }

            guard let data = data else {
                onComplete(.failure(IntentTestTaskError.corruptedData))
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
