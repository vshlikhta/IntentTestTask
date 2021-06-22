//
//  RepositoryListDecodeOperation.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

class RepositoryListDecodeOperation: Operation {
    var dataFetched: Data?
    var error: Error?
    var decodedURL: URL?
    typealias CompletionHandler = (_ result: Result<GithubRepositorySearchResponsePayload?, IntentTestTaskError>) -> Void
    var completionHandler: (CompletionHandler)?

    override func main() {
        guard let dataFetched = dataFetched else { return }
        do {
            let content = try JSONDecoder().decode(GithubRepositorySearchResponsePayload.self, from: dataFetched)
            completionHandler?(.success(content))
        } catch {
            self.error = error
            completionHandler?(.failure(.custom(error: error)))
        }
    }
}
