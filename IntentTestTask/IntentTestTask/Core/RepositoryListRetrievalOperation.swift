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
    var error: Error?
    var url: URL?
    
    init(url: URL? = nil, httpManager: T) {
        self.url = url
        self.httpManager = httpManager
    }
       
    override func main() {
        guard let url = url else {return}
        httpManager?.get(url: url, completionBlock: { data in
            switch data {
            case .failure(let error):
                self.error = error
                self.complete(result: data)
            case .success(let successdata):
                self.dataFetched = successdata
                self.complete(result: data)
            }
        })
    }
}
