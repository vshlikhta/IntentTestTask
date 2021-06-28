//
//  GithubSearchApiClientTests.swift
//  IntentTestTaskTests
//
//  Created by Volodymyr Shlikhta on 28.06.2021.
//

import XCTest
@testable import IntentTestTask

final class GithubSearchApiClientTests: XCTestCase {
    func test_loadRepositories_requestExecutorExecutedWithRequest() {
        let requestExecutor = SpyRequestExecutor()
        let sut = makeSUT(requestExecutor: requestExecutor)
    
        sut.loadRepositories(for: .dummySearch, onComplete: { _ in })
        
        XCTAssertTrue(requestExecutor.spyExecuteInvoked)
    }
    
    func test_loadRepositories_requestExecutedWithRepositoryListURL() throws {
        let requestExecutor = SpyRequestExecutor()
        let sut = makeSUT(requestExecutor: requestExecutor)
        let expectedURL = try RepositoryRequest.repositoryList(query: .dummySearch, page: Constants.Github.defaultPage).getMutableRequest().url
        
        sut.loadRepositories(for: .dummySearch, onComplete: { _ in })
        let url = try requestExecutor.spyRequest?.getMutableRequest().url
        
        XCTAssertEqual(url, expectedURL)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(requestExecutor: RequestExecutor) -> GithubSearchApiClient {
        return GithubSearchApiClient(requestExecutor: requestExecutor)
    }
}

final class SpyRequestExecutor: RequestExecutor {
    
    var spyExecuteInvoked = false
    var spyRequest: GettableRequest?
    
    func execute<DataType>(
        request: GettableRequest,
        onComplete: @escaping ((Result<DataType, IntentTestTaskError>) -> Void)
    ) where DataType : Decodable {
        spyExecuteInvoked = true
        spyRequest = request
    }
}

private extension String {
    static var dummySearch: String {
        return ""
    }
}
