//
//  GithubSearchPresenter.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

protocol GithubSearchPresenterAction: AnyObject {
    func didTapSearch(with query: String?)
    
    func didSelectSearchResult(at row: Int)
    func requestMoreResults()
}

protocol GithubSearchTableDataProvider: AnyObject {
    var state: ImmutableObservable<GithubSearchPresenter.State> { get }
    var numberOfItems: Int { get }
    
    func viewModel(for row: Int) -> SearchResultViewModel?
}

typealias GithubSearchPresenterInterface = GithubSearchPresenterAction & GithubSearchTableDataProvider

class GithubSearchPresenter {
    
    enum State {
        case loading
        case idle
    }
    
    var state: ImmutableObservable<State> {
        return internalState.immutable
    }
    private var internalState: Observable<State> = .init(.idle)
    
    private var storage: GithubRepositorySearchResponsePayload?
    private let apiClient: GithubSearchApiClientInterface = GithubSearchApiClient()
    private var searchResultItems = [SearchResultViewModel]()
    
    weak var controller: (URLOpenable & ControllerReloadable)?
    
}

extension GithubSearchPresenter: GithubSearchTableDataProvider {
    var numberOfItems: Int {
        return searchResultItems.count
    }
    
    func viewModel(for row: Int) -> SearchResultViewModel? {
        return searchResultItems.element(at: row)
    }
}

extension GithubSearchPresenter: GithubSearchPresenterAction {
    func didTapSearch(with query: String?) {
        internalState.value = .loading
        apiClient.start(with: query) { [weak self] data in
            self?.internalState.value = .idle
            guard let data = data else { return }
            self?.store(.new, data)
            Executor.main.execute {
                self?.controller?.reload()
            }
        }
    }
    
    func requestMoreResults() {
        guard storage?.isLastResult == false else {
            return
        }
        internalState.value = .loading
        apiClient.retrieveMoreRepositories { [weak self] data in
            self?.internalState.value = .idle
            guard let data = data else { return }
            self?.store(.additional, data)
            Executor.main.execute {
                self?.controller?.reload()
            }
        }
    }
    
    private func store(_ type: SearchResultViewModel.Origin, _ searchResult: GithubRepositorySearchResponsePayload) {
        storage = searchResult
        let newItems = searchResult.items.map { SearchResultViewModel(with: $0) }
        switch type {
        case .new:
            searchResultItems = newItems
        case .additional:
            searchResultItems = searchResultItems + newItems
        }
    }
    
    private func store(additional searchResult: GithubRepositorySearchResponsePayload) {
        storage = searchResult
        searchResultItems.append(contentsOf: searchResult.items.map { SearchResultViewModel(with: $0) })
    }
    
    func didSelectSearchResult(at row: Int) {
        let selectedViewModelId = searchResultItems.element(at: row)?.id
        let selectedUrl = storage?.items.first { $0.id == selectedViewModelId }?.url
        
        Executor.main.execute {
            try? self.controller?.open(selectedUrl)
        }
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

extension Array {
    func element(at index: Int) -> Element? {
        return enumerated().first { $0.offset == index }?.element
    }
}

fileprivate extension SearchResultViewModel {
    enum Origin {
        case new
        case additional
    }
}
