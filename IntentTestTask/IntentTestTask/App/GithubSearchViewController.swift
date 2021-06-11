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
    private var disposeBag = Disposal()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var searchTextfield: UITextField! {
        didSet {
            searchTextfield.delegate = self
        }
    }
    
    @IBOutlet private weak var searchButton: UIButton! {
        didSet {
            searchButton.setTitle("Search", for: .normal)
        }
    }
    
    @IBOutlet private weak var searchResultsTableView: UITableView! {
        didSet {
            searchResultsTableView.estimatedRowHeight = 200
            searchResultsTableView.rowHeight = UITableView.automaticDimension
            searchResultsTableView.tableFooterView = UIView()
            
            searchResultsTableView.register(SearchResultTableViewCell.self)
            
            searchResultsTableView.dataSource = self
            searchResultsTableView.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        searchTextfield.resignFirstResponder()
        presenter.didTapSearch(with: searchTextfield.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter
            .state
            .observe(DispatchQueue.main) { state, _ in
                switch state {
                case .idle:
                    self.activityIndicatorView.stopAnimating()
                case .loading:
                    self.activityIndicatorView.startAnimating()
                }
        }.add(to: &disposeBag)
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
        guard let viewModel = presenter.viewModel(for: indexPath.row) else { return UITableViewCell() }
        
        let cell: SearchResultTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setup(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row.distance(to: presenter.numberOfItems) < 3 {
            presenter.requestMoreResults()
        }
    }
}

// MARK: - UITableViewDelegate
extension GithubSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectSearchResult(at: indexPath.row)
    }
}

extension GithubSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextfield.resignFirstResponder()
        return true
    }
}
