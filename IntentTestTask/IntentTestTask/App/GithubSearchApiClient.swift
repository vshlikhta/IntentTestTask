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

final class GithubSearchApiClient: GithubSearchApiClientInterface, RequestExecutable {
    typealias RepositoryRetrieveResponse = (Result<GithubRepositorySearchResponsePayload?, IntentTestTaskError>) -> Void
    
    // MARK: - Properties
    
    private var lastRetrieveRequest: RepositoryRequest?
    
    // MARK: - Methods
    
    func loadRepositories(for query: String?, onComplete: @escaping RepositoryRetrieveResponse) {
        retrieveRepositoryList(for: query, page: Constants.Github.defaultPage, onComplete)
    }
    
    func retrieveMoreRepositories(onComplete: @escaping RepositoryRetrieveResponse) {
        if case .repositoryList(let query, let page) = lastRetrieveRequest {
            retrieveRepositoryList(for: query, page: page.incremented, onComplete)
        }
    }
    
    private func retrieveRepositoryList(for query: String?,
                                        page: String,
                                        _ onComplete: @escaping RepositoryRetrieveResponse) {
        let retrieveRequest = RepositoryRequest.repositoryList(query: query, page: page)
        
        execute(request: retrieveRequest) { [weak self] (result: Result<GithubRepositorySearchResponsePayload?, IntentTestTaskError>) in
            switch result {
            case .success(let data):
                self?.lastRetrieveRequest = retrieveRequest
                onComplete(.success(data))
            case .failure(let error):
                onComplete(.failure(error))
            }
        }
    }
}
