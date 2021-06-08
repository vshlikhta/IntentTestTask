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

