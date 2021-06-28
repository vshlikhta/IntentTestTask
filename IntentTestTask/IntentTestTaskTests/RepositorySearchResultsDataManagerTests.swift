//
//  RepositorySearchResultsDataManagerTests.swift
//  IntentTestTaskTests
//
//  Created by Volodymyr Shlikhta on 28.06.2021.
//

import XCTest
@testable import IntentTestTask

final class RepositorySearchResultsDataManagerTests: XCTestCase {
    func test_itemsIsEmpty_isMoreAvailableEqualFalse() {
        let responseStorage = StubGithubRepositorySearchResponseStorage()
        responseStorage.items = []
        let sut = makeSUT(storage: responseStorage)
        
        XCTAssertFalse(sut.isMoreAvailable)
    }
    
    func test_itemIsLastResult_isMoreAvailableEqualFalse() {
        let responseStorage = StubGithubRepositorySearchResponseStorage()
        responseStorage.items = [.make(isLastResult: true)]
        let sut = makeSUT(storage: responseStorage)
        
        XCTAssertFalse(sut.isMoreAvailable)
    }
    
    func test_itemIsLastResultEqualFalse_isMoreAvailableEqualTrue() {
        let responseStorage = StubGithubRepositorySearchResponseStorage()
        responseStorage.items = [.make(isLastResult: false)]
        let sut = makeSUT(storage: responseStorage)
        
        XCTAssertTrue(sut.isMoreAvailable)
    }
    
    func test_itemsLastItemIsLastResultEqualTrue_isMoreAvailableEqualFalse() {
        let responseStorage = StubGithubRepositorySearchResponseStorage()
        responseStorage.items = [.make(isLastResult: false), .make(isLastResult: true)]
        let sut = makeSUT(storage: responseStorage)
        
        XCTAssertFalse(sut.isMoreAvailable)
    }
    
    func test_itemsLastItemIsLastResultEqualFalse_isMoreAvailableEqualTrue() {
        let responseStorage = StubGithubRepositorySearchResponseStorage()
        responseStorage.items = [.make(isLastResult: false), .make(isLastResult: false)]
        let sut = makeSUT(storage: responseStorage)
        
        XCTAssertTrue(sut.isMoreAvailable)
    }
    
    func test_ItemWithId_emptyItemsReturnsNilResult() {
        let responseStorage = StubGithubRepositorySearchResponseStorage()
        responseStorage.items = []
        let sut = makeSUT(storage: responseStorage)
        
        XCTAssertNil(sut.item(with: .dummyId))
    }
    
    func test_ItemWithId_itemsContainsSeachedElementReturnsCorrectItem() {
        let responseStorage = StubGithubRepositorySearchResponseStorage()
        let stub: GithubRepositorySearchItemResponse = .make()
        responseStorage.items = [.make(items: [stub])]
        let sut = makeSUT(storage: responseStorage)
        
        XCTAssertEqual(stub, sut.item(with: stub.id))
    }
    
    func test_ItemWithId_itemsContainsSearchedElementInMultipleElementsReturnsCorrectItem() {
        let responseStorage = StubGithubRepositorySearchResponseStorage()
        let stub: GithubRepositorySearchItemResponse = .make()
        let alteredStub: GithubRepositorySearchItemResponse = .make(id: stub.id.incremented)
        responseStorage.items = [.make(items: [stub, alteredStub])]
        let sut = makeSUT(storage: responseStorage)
        
        XCTAssertEqual(stub, sut.item(with: stub.id))
    }
    
    func test_ItemWithId_itemsMissingSearchedElementInMultipleElementsReturnsNil() {
        let responseStorage = StubGithubRepositorySearchResponseStorage()
        let stub: GithubRepositorySearchItemResponse = .make()
        responseStorage.items = [.make(items: [stub])]
        let sut = makeSUT(storage: responseStorage)
        
        let alteredStub: GithubRepositorySearchItemResponse = .make(id: stub.id.incremented)
        
        XCTAssertNil(sut.item(with: alteredStub.id))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(storage: GithubRepositorySearchResponseStorage) -> RepositorySearchResultsDataManager {
        return RepositorySearchResultsDataManager(storage: storage)
    }
}

private extension Int {
    static var dummyId: Int {
        return -1
    }
}

private final class StubGithubRepositorySearchResponseStorage: GithubRepositorySearchResponseStorage {
    var items: [GithubRepositorySearchResponsePayload] = .init()
}

private extension GithubRepositorySearchResponsePayload {
    static func make(totalCount: Int = 0,
                     isLastResult: Bool = true,
                     items: [GithubRepositorySearchItemResponse] = [])
    -> GithubRepositorySearchResponsePayload {
        return .init(totalCount: totalCount, isLastResult: isLastResult, items: items)
    }
}

private extension GithubRepositorySearchItemResponse {
    static func make(id: Int = 0,
                     fullName: String = "John Doe",
                     description: String? = "Testing Description",
                     isPrivate: Bool = false,
                     url: String = "https://github.com/vshlikhta/IntentTestTask",
                     language: String? = "Swift") -> GithubRepositorySearchItemResponse {
        return .init(id: id,
                     fullName: fullName,
                     description: description,
                     isPrivate: isPrivate,
                     url: url,
                     language: language)
    }
}
