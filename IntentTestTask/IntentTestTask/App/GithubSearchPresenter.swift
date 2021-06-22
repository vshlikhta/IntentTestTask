//
//  GithubSearchPresenter.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

protocol GithubSearchTableDataProvider: AnyObject {
    var state: ImmutableObservable<GithubSearchPresenter.State> { get }
    var numberOfItems: Int { get }
    
    func viewModel(for row: Int) -> SearchResultViewModel?
}

typealias GithubSearchPresenterInterface = GithubSearchTableDataProvider

class GithubSearchPresenter {
    
    enum State {
        case loading
        case idle
    }
    
    // MARK: - Properties
    
    var state: ImmutableObservable<State> {
        return internalState.immutable
    }
    
    private var internalState: Observable<State> = .init(.idle)
    private var disposeBag = Disposal()
    
    private let apiClient: GithubSearchApiClientInterface = GithubSearchApiClient()
    private let storage = GithubSearchResultsDataManager()
    
    private weak var controller: GithubSearchViewControllerInterface?
    
    init(with controller: GithubSearchViewControllerInterface) {
        self.controller = controller
        
        storage.searchResultsObservable.observe { [weak self] _, _ in
            self?.controller?.reload()
        }.add(to: &disposeBag)
        
        controller.requestSearchResultsObservable.observe { [weak self] request, _ in
            switch request {
            case .initial:
                ()
            case .new(let query):
                self?.requestRepositories(for: query)
            case .more:
                guard self?.storage.isMoreAvailable == true else { return }
                self?.requestMoreResults()
            }
        }.add(to: &disposeBag)
        
        controller.searchResultSelectObservable.observe { [weak self] row, _ in
            guard let row = row else { return }
            self?.didSelectSearchResult(at: row)
        }.add(to: &disposeBag)
    }
}

extension GithubSearchPresenter: GithubSearchTableDataProvider {
    var numberOfItems: Int {
        return storage.searchResultsObservable.value.count
    }
    
    func viewModel(for row: Int) -> SearchResultViewModel? {
        return storage.searchResultsObservable.value.element(at: row)
    }
}

extension GithubSearchPresenter {
    private func requestRepositories(for query: String?) {
        internalState.value = .loading
        apiClient.loadRepositories(for: query) { [weak self] result in
            self?.internalState.value = .idle
            switch result {
            case .success(let data):
                guard let data = data else { return }
                self?.storage.store(.new, data)
            case .failure(let error):
                self?.controller?.show(alert: error.asAlert)
            }
        }
    }
    
    private func requestMoreResults() {
        internalState.value = .loading
        apiClient.retrieveMoreRepositories { [weak self] result in
            self?.internalState.value = .idle
            switch result {
            case .success(let data):
                guard let data = data else { return }
                self?.storage.store(.additional, data)
            case .failure(let error):
                self?.controller?.show(alert: error.asAlert)
            }
        }
    }
    
    private func didSelectSearchResult(at row: Int) {
        guard let selectedViewModelId = storage.searchResultsObservable.value.element(at: row)?.id else { return }
        let itemData = storage.item(with: selectedViewModelId)
        
        Executor.main.execute {
            try? self.controller?.open(itemData?.url)
        }
    }
}
