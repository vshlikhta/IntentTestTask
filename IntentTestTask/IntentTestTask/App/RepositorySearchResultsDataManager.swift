//
//  GithubSearchResultsDataManager.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 22.06.2021.
//

import Foundation

protocol GithubSearchResultsDataManagerInterface: AnyObject {
    var searchResultsObservable: ImmutableObservable<[SearchResultViewModel]> { get }
    var isMoreAvailable: Bool { get }
    
    func store(_ type: RepositorySearchResultsDataManager.DataOrigin, _ searchResult: GithubRepositorySearchResponsePayload)
    func item(with id: Int) -> GithubRepositorySearchItemResponse?
}

final class RepositorySearchResultsDataManager {
    
    enum DataOrigin {
        case new
        case additional
    }
    
    // MARK: - Properties
    
    private var searchResultsSubject: Observable<[SearchResultViewModel]> = .init([])
    
    private var storage = [GithubRepositorySearchResponsePayload]()
    private var storageItems: [GithubRepositorySearchItemResponse] {
        return storage.map(\.items).flatMap { $0 }
    }
    
    private var searchResultItems: [SearchResultViewModel] {
        return storageItems.map(SearchResultViewModel.init)
    }
}

// MARK: - GithubSearchResultsDataManagerInterface
extension RepositorySearchResultsDataManager: GithubSearchResultsDataManagerInterface {
    var isMoreAvailable: Bool {
        return storage.last?.isLastResult == false
    }
    
    var searchResultsObservable: ImmutableObservable<[SearchResultViewModel]> {
        return searchResultsSubject.immutable
    }
    
    func store(_ type: DataOrigin, _ searchResult: GithubRepositorySearchResponsePayload) {
        switch type {
        case .new:
            storage = [searchResult]
        case .additional:
            storage.append(searchResult)
        }
        
        searchResultsSubject.value = searchResultItems
    }
    
    func item(with id: Int) -> GithubRepositorySearchItemResponse? {
        return storageItems.first { $0.id == id }
    }
}

fileprivate extension SearchResultViewModel {
    init(with searchItem: GithubRepositorySearchItemResponse) {
        id = searchItem.id
        title = searchItem.fullName
        description = searchItem.description
        language = searchItem.language
        isPrivate = searchItem.isPrivate
    }
}
