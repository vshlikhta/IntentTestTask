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
    typealias CompletionHandler = (_ result: GithubRepositorySearchResponsePayload?) -> Void
    var completionHandler: (CompletionHandler)?

    override func main() {
        guard let dataFetched = dataFetched else { return }
        let decoder = JSONDecoder()
        do {
            let content = try decoder.decode(GithubRepositorySearchResponsePayload.self, from: dataFetched)
            completionHandler?(content)
//            if let id = content.data.first?.id {
//                  self.decodedURL = URL(string: Constants.baseURL + "/" + String(id) )
//                completionHandler?(content)
//            } else {
//                self.error = IntentTestTaskError.general
//                completionHandler?(nil)
//            }
        } catch {
            self.error = error
            completionHandler?(nil)
        }
    }
}
