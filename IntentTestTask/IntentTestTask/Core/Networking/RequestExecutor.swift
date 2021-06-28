//
//  RequestExecutable.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 24.06.2021.
//

import Foundation

protocol GettableRequest {
    func getMutableRequest() throws -> URLRequest
}

protocol RequestExecutor: AnyObject {
    func execute<DataType: Decodable>
        (request: GettableRequest,
         onComplete: @escaping ((Result<DataType, IntentTestTaskError>) -> Void)
        )
}

final class DefaultRequestExecutor: RequestExecutor {
    private let sessionManager: NetworkSessionManager
    
    init(sessionManager: NetworkSessionManager = DefaultNetworkSessionManager()) {
        self.sessionManager = sessionManager
    }
    
    func execute<DataType: Decodable>
        (request: GettableRequest,
         onComplete: @escaping ((Result<DataType, IntentTestTaskError>) -> Void)
        ) {
        guard let urlRequest = try? request.getMutableRequest() else {
            onComplete(.failure(.corruptedRequest))
            return
        }
        
        sessionManager.request(urlRequest, completion: { (responseData, response, error) in
            if let error = error {
                onComplete(.failure(.custom(error: error)))
                return
            }
            
            guard let responseData = responseData else {
                onComplete(.failure(.missingData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(DataType.self, from: responseData)
                onComplete(.success(result))
            } catch {
                print(error)
                onComplete(.failure(.corruptedData))
            }
        })
    }
}
