//
//  RepositoryListRetrievalOperation.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

class RepositoryListRetrievalOperation<T: HTTPManagerProtocol>: NetworkOperation {
    var dataFetched: Data?
    var httpManager: T?
    var error: IntentTestTaskError?
    var request: URLRequest?
    
    init(request: URLRequest? = nil, httpManager: T) {
        self.request = request
        self.httpManager = httpManager
    }
    
    override func main() {
        guard let request = request else { return }
        httpManager?.perform(request: request, onComplete: { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataFetched = data
            case .failure(let err):
                self?.error = err
            }
            self?.complete(result: result)
        })
    }
}
