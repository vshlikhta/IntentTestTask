//
//  GithubRepositorySearchItemResponse.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 11.06.2021.
//

import Foundation

struct GithubRepositorySearchItemResponse: Decodable {
    let id: Int
    let fullName: String
    let description: String?
    let isPrivate: Bool
    let url: String
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case isPrivate = "private"
        case url = "html_url"
        case description
        case language
    }
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
