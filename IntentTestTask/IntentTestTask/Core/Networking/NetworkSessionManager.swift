//
//  NetworkSessionManager.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 24.06.2021.
//

import Foundation

public typealias URLSessionDataTaskCompletion = (Data?, URLResponse?, Error?) -> Void

public protocol NetworkSessionManager {
    @discardableResult
    func request(_ request: URLRequest,
                 completion: @escaping URLSessionDataTaskCompletion) -> URLSessionDataTask
}

public final class DefaultNetworkSessionManager: NetworkSessionManager {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    @discardableResult
    public func request(_ request: URLRequest,
                        completion: @escaping URLSessionDataTaskCompletion) -> URLSessionDataTask {
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}
