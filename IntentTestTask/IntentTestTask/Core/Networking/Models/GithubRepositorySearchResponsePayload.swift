//
//  GithubRepositorySearchResponsePayload.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 11.06.2021.
//

import Foundation

struct GithubRepositorySearchResponsePayload: Decodable {
    
    let totalCount: Int
    let isLastResult: Bool
    let items: [GithubRepositorySearchItemResponse]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case isLastResult = "incomplete_results"
        case items
    }
}
