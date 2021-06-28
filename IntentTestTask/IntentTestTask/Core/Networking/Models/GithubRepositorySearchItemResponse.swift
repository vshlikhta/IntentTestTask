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

extension GithubRepositorySearchItemResponse: Equatable {
    static func == (lhs: GithubRepositorySearchItemResponse, rhs: GithubRepositorySearchItemResponse) -> Bool {
        return lhs.fullName == rhs.fullName &&
            lhs.id == rhs.id &&
            lhs.isPrivate == rhs.isPrivate &&
            lhs.language == rhs.language &&
            lhs.language == rhs.language
    }
}
