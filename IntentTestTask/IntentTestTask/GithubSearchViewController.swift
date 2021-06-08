//
//  ViewController.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import UIKit

class GithubSearchViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    // MARK: - Actions
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

