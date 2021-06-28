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
    
    func test_itemWithId_itemsContainsSeachedElementReturnsCorrectItem() {
        let expectedResult: GithubRepositorySearchItemResponse = .make()
        let sut = makeSUT(items: [.make(items: [expectedResult])])
        
        XCTAssertEqual(expectedResult, sut.item(with: expectedResult.id))
    }
    
    func test_itemWithId_itemsContainsSearchedElementInMultipleElementsReturnsCorrectItem() {
        let expectedResult: GithubRepositorySearchItemResponse = .make()
        let additionalResult: GithubRepositorySearchItemResponse = .make(id: expectedResult.id.incremented)
        let sut = makeSUT(items: [.make(items: [expectedResult, additionalResult])])
        
        XCTAssertEqual(expectedResult, sut.item(with: expectedResult.id))
    }
    
    func test_itemWithId_itemsMissingSearchedElementInMultipleElementsReturnsNil() {
        let stub: GithubRepositorySearchItemResponse = .make()
        let alteredStub: GithubRepositorySearchItemResponse = .make(id: stub.id.incremented)
        let sut = makeSUT(items: [.make(items: [stub])])
        
        XCTAssertNil(sut.item(with: alteredStub.id))
    }
    
    func test_storeTypeSearchResult_storageSavedNewArray() {
        let oldResult: GithubRepositorySearchResponsePayload = .make(items: [.make(id: 0)])
        let newResult: GithubRepositorySearchResponsePayload = .make(items: [.make(id: 1)])
        let spyRepositoryStorage = SpyGithubRepositorySearchResponseStorage()
        let sut = makeSUT(storage: spyRepositoryStorage)
        
        sut.store(.new, oldResult)
        XCTAssertEqual(spyRepositoryStorage.items, [oldResult])
        
        sut.store(.new, newResult)
        XCTAssertEqual(spyRepositoryStorage.items, [newResult])
    }
    
    func test_storeTypeSearchResult_storageSavedAdditional() {
        let oldResult: GithubRepositorySearchResponsePayload = .make(items: [.make(id: 0)])
        let newResult: GithubRepositorySearchResponsePayload = .make(items: [.make(id: 1)])
        let expectedResult = [oldResult, newResult]
        let spyRepositoryStorage = SpyGithubRepositorySearchResponseStorage()
        let sut = makeSUT(storage: spyRepositoryStorage)
        
        sut.store(.additional, oldResult)
        sut.store(.additional, newResult)
        
        XCTAssertEqual(spyRepositoryStorage.items, expectedResult)
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
    
    static var dummyTotalCount: Int {
        return -1
    }
}

private final class SpyGithubRepositorySearchResponseStorage: GithubRepositorySearchResponseStorage {
    var items: [GithubRepositorySearchResponsePayload] = .init()
}

private final class StubGithubRepositorySearchResponseStorage: GithubRepositorySearchResponseStorage {
    var items: [GithubRepositorySearchResponsePayload] = .init()
    
    internal init(items: [GithubRepositorySearchResponsePayload] = .init()) {
        self.items = items
    }
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
