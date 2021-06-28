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
        let sut = makeSUT(items: [])
        
        XCTAssertFalse(sut.isMoreAvailable)
    }
    
    func test_itemIsLastResult_isMoreAvailableEqualFalse() {
        let sut = makeSUT(items: [.make(isLastResult: true)])
        
        XCTAssertFalse(sut.isMoreAvailable)
    }
    
    func test_itemIsLastResultEqualFalse_isMoreAvailableEqualTrue() {
        let sut = makeSUT(items: [.make(isLastResult: false)])
        
        XCTAssertTrue(sut.isMoreAvailable)
    }
    
    func test_itemsLastItemIsLastResultEqualTrue_isMoreAvailableEqualFalse() {
        let sut = makeSUT(items: [.make(isLastResult: false),
                                  .make(isLastResult: true)])
        
        XCTAssertFalse(sut.isMoreAvailable)
    }
    
    func test_itemsLastItemIsLastResultEqualFalse_isMoreAvailableEqualTrue() {
        let sut = makeSUT(items: [.make(isLastResult: true),
                                  .make(isLastResult: false)])
        
        XCTAssertTrue(sut.isMoreAvailable)
    }
    
    func test_itemWithId_emptyItemsReturnsNilResult() {
        let sut = makeSUT(items: [])
        
        XCTAssertNil(sut.item(with: .dummyId))
    }
    
    func test_ItemWithId_itemsContainsSeachedElementReturnsCorrectItem() {
        let stub: GithubRepositorySearchItemResponse = .make()
        let sut = makeSUT(items: [.make(items: [stub])])
        
        XCTAssertEqual(stub, sut.item(with: stub.id))
    }
    
    func test_ItemWithId_itemsContainsSearchedElementInMultipleElementsReturnsCorrectItem() {
        let stub: GithubRepositorySearchItemResponse = .make()
        let alteredStub: GithubRepositorySearchItemResponse = .make(id: stub.id.incremented)
        
        let sut = makeSUT(items: [.make(items: [stub, alteredStub])])
        
        XCTAssertEqual(stub, sut.item(with: stub.id))
    }
    
    func test_ItemWithId_itemsMissingSearchedElementInMultipleElementsReturnsNil() {
        let stub: GithubRepositorySearchItemResponse = .make()
        let alteredStub: GithubRepositorySearchItemResponse = .make(id: stub.id.incremented)
        
        let sut = makeSUT(items: [.make(items: [stub])])
        
        XCTAssertNil(sut.item(with: alteredStub.id))
    }
    
    func test_storeTypeSearchResult_newItemStoredReplacingPrevious() {
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(storage: GithubRepositorySearchResponseStorage) -> RepositorySearchResultsDataManager {
        return RepositorySearchResultsDataManager(storage: storage)
    }
    
    private func makeSUT(items: [GithubRepositorySearchResponsePayload]) -> RepositorySearchResultsDataManager {
        let storage = StubGithubRepositorySearchResponseStorage()
        storage.items = items
        return makeSUT(storage: storage)
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
