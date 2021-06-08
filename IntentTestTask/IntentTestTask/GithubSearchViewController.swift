//
//  ViewController.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import UIKit

class GithubSearchViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var presenter: GithubSearchPresenter = {
        return GithubSearchPresenter()
    }()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchTextfield: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
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
        
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension GithubSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension GithubSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
