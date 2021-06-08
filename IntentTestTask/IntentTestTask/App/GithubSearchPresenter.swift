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
}

protocol GithubSearchTableDataProvider: AnyObject {
    var numberOfItems: Int { get }
    
    func viewModel(for row: Int) -> SearchResultViewModel
}

class GithubSearchPresenter {
    private var storage = [GithubRepositorySearchResponsePayload]()
    
}

extension GithubSearchPresenter: GithubSearchTableDataProvider {
    var numberOfItems: Int {
        return storage.count
    }
    
    func viewModel(for row: Int) -> SearchResultViewModel {
        return SearchResultViewModel(id: "",
                                     title: "",
                                     description: "",
                                     language: "",
                                     isPrivate: true,
                                     licenseDescription: "")
    }
}

extension GithubSearchPresenter: GithubSearchPresenterAction {
    func didTapSearch(with query: String?) {
        
    }
    
    func didSelectSearchResult(at row: Int) {
        
    }
}

struct GithubRepositorySearchResponsePayload: Decodable {
    
}
