//
//  ViewController.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import UIKit

protocol RepositorySearchViewControllerInterface: ControllerReloadable, URLOpenable, ErrorPresentable {
    var requestSearchResultsObservable: ImmutableObservable<RepositorySearchViewController.SearchRequest> { get }
    var searchResultSelectObservable: ImmutableObservable<Int?> { get }
}

class RepositorySearchViewController: UIViewController {

    enum SearchRequest {
        case initial
        case new(query: String?)
        case more
    }
    
    // MARK: - Properties
    
    private lazy var presenter: RepositorySearchTableDataProvider = {
        return RepositorySearchPresenter(with: self)
    }()
    private var disposeBag = Disposal()
    private var requestSearchResultsSubject: Observable<SearchRequest> = .init(.initial)
    private var searchResultSelectSubject: Observable<Int?> = .init(nil)
    
    // MARK: - Outlets
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var searchTextfield: UITextField! {
        didSet { searchTextfield.delegate = self }
    }
    
    @IBOutlet private weak var searchButton: UIButton! {
        didSet { searchButton.setTitle("Search", for: .normal) }
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
        requestSearchResultsSubject.value = .new(query: searchTextfield.text)
    }
    
    // MARK: - Controller lifecycle
    
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

// MARK: - RepositorySearchViewControllerInterface
extension RepositorySearchViewController: RepositorySearchViewControllerInterface {
    var requestSearchResultsObservable: ImmutableObservable<SearchRequest> {
        return requestSearchResultsSubject.immutable
    }
    
    var searchResultSelectObservable: ImmutableObservable<Int?> {
        return searchResultSelectSubject.immutable
    }
    
    func reload() {
        Executor.main.execute {
            self.searchResultsTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension RepositorySearchViewController: UITableViewDataSource {
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
        if shouldLoadMoreItems(forRowAt: indexPath) {
            requestSearchResultsSubject.value = .more
        }
    }
    
    private func shouldLoadMoreItems(forRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row.distance(to: presenter.numberOfItems) < 3
    }
}

// MARK: - UITableViewDelegate
extension RepositorySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchResultSelectSubject.value = indexPath.row
    }
}

extension RepositorySearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextfield.resignFirstResponder()
        return true
    }
}
