//
//  ViewController.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import UIKit

class GithubSearchViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var presenter: GithubSearchPresenterInterface = {
        let presenter = GithubSearchPresenter()
        presenter.controller = self
        return presenter
    }()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchTextfield: UITextField!
    
    @IBOutlet private weak var searchButton: UIButton! {
        didSet {
            searchButton.setTitle("Search", for: .normal)
        }
    }
    
    @IBOutlet private weak var searchResultsTableView: UITableView! {
        didSet {
            searchResultsTableView.estimatedRowHeight = 200
            searchResultsTableView.rowHeight = UITableView.automaticDimension
            
            searchResultsTableView.register(SearchResultTableViewCell.self)
            
            searchResultsTableView.dataSource = self
            searchResultsTableView.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        presenter.didTapSearch(with: searchTextfield.text)
    }
}

// MARK: - ControllerReloadable
extension GithubSearchViewController: ControllerReloadable {
    func reload() {
        Executor.main.execute {
            self.searchResultsTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension GithubSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setup(with: presenter.viewModel(for: indexPath.row))
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GithubSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectSearchResult(at: indexPath.row)
    }
}
