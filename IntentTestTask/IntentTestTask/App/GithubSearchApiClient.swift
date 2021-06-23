//
//  GithubSearchApiClient.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

protocol GithubSearchApiClientInterface: AnyObject {
    func loadRepositories(for query: String?, onComplete: @escaping GithubSearchApiClient.RepositoryRetrieveResponse)
    func retrieveMoreRepositories(onComplete: @escaping GithubSearchApiClient.RepositoryRetrieveResponse)
}

final class GithubSearchApiClient: GithubSearchApiClientInterface {
    typealias RepositoryRetrieveResponse = (Result<GithubRepositorySearchResponsePayload?, IntentTestTaskError>) -> Void
    
    // MARK: - Properties
    
    private let queueManager = QueueManager.shared
    private let httpManager = HTTPManager(session: URLSession.shared)
    
    private var lastRetrieveRequest: RepositoryRequest?
    
    // MARK: - Methods
    
    func loadRepositories(for query: String?, onComplete: @escaping RepositoryRetrieveResponse) {
        queueManager.cancelAllOperations()
        lastRetrieveRequest = nil
        retrieveRepositoryList(for: query, page: "1", onComplete)
    }
    
    func retrieveMoreRepositories(onComplete: @escaping RepositoryRetrieveResponse) {
        if case .repositoryList(let query, let page) = lastRetrieveRequest {
            retrieveRepositoryList(for: query,
                                   page: page.incremented,
                                   onComplete)
        }
    }
    
    private func retrieveRepositoryList(for query: String?,
                                        page: String,
                                        _ onComplete: @escaping RepositoryRetrieveResponse) {
        let retrieveRequest = RepositoryRequest.repositoryList(query: query, page: page)
        
        guard let mutableRequest = try? retrieveRequest.getMutableRequest() else { return }
        
        let fetch = RepositoryListRetrievalOperation(request: mutableRequest,
                                                     httpManager: httpManager)
        fetch.completionHandler = { [weak self] result in
            if case .failure(let err) = result {
                self?.queueManager.cancelAllOperations()
                onComplete(.failure(err))
            }
        }
        
        let parse = RepositoryListDecodeOperation()
        
        parse.completionHandler = { [weak self] result in
            switch result {
            case .success(let data):
                self?.lastRetrieveRequest = retrieveRequest
                onComplete(.success(data))
            case .failure(let err):
                onComplete(.failure(err))
            }
        }
        
        let adapter = BlockOperation() { [unowned fetch, unowned parse] in
            parse.dataFetched = fetch.dataFetched
        }
        
        adapter.addDependency(fetch)
        parse.addDependency(adapter)
        
        queueManager.addOperations([fetch, adapter, parse])
    }
}
