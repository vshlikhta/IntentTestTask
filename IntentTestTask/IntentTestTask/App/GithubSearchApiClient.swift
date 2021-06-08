//
//  GithubSearchApiClient.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

class GithubSearchApiClient {
    private let queueManager: QueueManager
    
    init(with queueManager: QueueManager = QueueManager.shared) {
        self.queueManager = queueManager
    }
    
    func retrieveRepositoryList(completionBlock: @escaping (GithubRepositorySearchResponsePayload?) -> Void) {
        guard let url = URL(string: Constants.baseURL) else { return }
        let fetch = RepositoryListRetrievalOperation(url: url,
                                                     httpManager: HTTPManager(session: URLSession.shared))
        let parse = RepositoryListDecodeOperation()
        
        
        let adapter = BlockOperation() { [unowned fetch, unowned parse] in
            parse.dataFetched = fetch.dataFetched
            parse.error = fetch.error
        }
        
        adapter.addDependency(fetch)
        parse.addDependency(adapter)
        
        parse.completionHandler = { data in
            completionBlock(data)
        }
        queueManager.addOperations([fetch, parse, adapter])
    }
}
