//
//  SearchResultTableViewCell.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import UIKit

struct SearchResultViewModel {
    let id: String
    let title: String
    let description: String
    let language: String
    let isPrivate: Bool
    let licenseDescription: String
}

//{
//  "total_count": 40,
//  "incomplete_results": false,
//  "items": [
//    {
//      "id": 3081286,
//      "full_name": "dtrupenn/Tetris",
//      "private": false,
//      "html_url": "https://github.com/dtrupenn/Tetris",
//      "description": "A C implementation of Tetris using Pennsim through LC4",
//      "language": "Assembly",
//      "license": {
//        "name": "MIT License",
//      }
//    }
//  ]
//}

class SearchResultTableViewCell: UITableViewCell, CellLoadable {
    
}
