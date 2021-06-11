//
//  GithubSearchApiClient.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

protocol GithubSearchApiClientInterface: AnyObject {
    func start(with query: String?, onComplete: @escaping (GithubRepositorySearchResponsePayload?) -> Void)
    func retrieveMoreRepositories(onComplete: @escaping (GithubRepositorySearchResponsePayload?) -> Void)
}

class GithubSearchApiClient: GithubSearchApiClientInterface {
    typealias RepositoryRetrieveResponse = (GithubRepositorySearchResponsePayload?) -> Void
    
    // MARK: - Properties
    
    private let queueManager = QueueManager.shared
    private let httpManager = HTTPManager(session: URLSession.shared)
    // NOTE: - There probably is a better way to manage last request
    private var lastRetrieveRequest: RepositoryRequest?
    
    // MARK: - Methods
    
    func start(with query: String?, onComplete: @escaping RepositoryRetrieveResponse) {
        queueManager.cancelAllOperations()
        lastRetrieveRequest = nil
        retrieveRepositoryList(for: query, page: "1", onComplete: onComplete)
    }
    
    func retrieveMoreRepositories(onComplete: @escaping RepositoryRetrieveResponse) {
        guard let lastRetrieveRequest = lastRetrieveRequest else { return }
        switch lastRetrieveRequest {
        case .repositoryList(let query, let page):
            retrieveRepositoryList(for: query,
                                   page: page.incremented,
                                   onComplete: onComplete)
        }
    }
    
    private func retrieveRepositoryList(for query: String?,
                                        page: String,
                                        onComplete: @escaping RepositoryRetrieveResponse) {
        let retrieveRequest = RepositoryRequest.repositoryList(query: query, page: page)
        
        guard let mutableRequest = try? retrieveRequest.getMutableRequest() else { return }
        
        let fetch = RepositoryListRetrievalOperation(request: mutableRequest,
                                                     httpManager: httpManager)
        let parse = RepositoryListDecodeOperation()
        
        let adapter = BlockOperation() { [unowned fetch, unowned parse] in
            parse.dataFetched = fetch.dataFetched
            parse.error = fetch.error
        }
        
        adapter.addDependency(fetch)
        parse.addDependency(adapter)
        
        parse.completionHandler = { [weak self] data in
            self?.lastRetrieveRequest = retrieveRequest
            onComplete(data)
        }
        
        queueManager.addOperations([fetch, parse, adapter])
    }
}
