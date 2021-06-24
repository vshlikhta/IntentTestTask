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

protocol RequestExecutable: AnyObject {
    func execute<DataType: Decodable>
        (request: GettableRequest,
         onComplete: @escaping ((Result<DataType, IntentTestTaskError>) -> Void)
        )
    
    func execute<DataType: Decodable, ErrorModel: Decodable>
        (request: GettableRequest,
         onComplete: @escaping ((Result<(data: DataType?, error: ErrorModel?), IntentTestTaskError>) -> Void)
        )
}

extension RequestExecutable {
    func execute<DataType: Decodable>
        (request: GettableRequest,
         onComplete: @escaping ((Result<DataType, IntentTestTaskError>) -> Void)
        ) {
        execute(request: request) { (result: Result<(data: DataType?, error: ErrorModelMock?), IntentTestTaskError>) in
            switch result {
            case .failure(let err):
                onComplete(.failure(err))
            case .success(let response):
                guard let data = response.data else {
                    onComplete(.failure(.corruptedData))
                    return
                }
                onComplete(.success(data))
            }
        }
    }
    
    func execute<DataType: Decodable, ErrorModel: Decodable>
        (request: GettableRequest,
         onComplete: @escaping ((Result<(data: DataType?, error: ErrorModel?), IntentTestTaskError>) -> Void)
        ) {
        
        guard let urlRequest = try? request.getMutableRequest() else {
            onComplete(.failure(.corruptedRequest))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (responseData, response, error) in
            if let error = error {
                onComplete(.failure(.custom(error: error)))
                return
            }
            
            guard let responseData = responseData else {
                onComplete(.failure(.missingData))
                return
            }
            
            let errorRepsonse = try? JSONDecoder().decode(ErrorModel.self, from: responseData)
            
            if let errorData = errorRepsonse {
                onComplete(.success((data: nil, error: errorData)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(DataType.self, from: responseData)
                onComplete(.success((data: result, error: nil)))
            } catch {
                print(error)
                onComplete(.failure(.corruptedData))
            }
            
            }.resume()
        
    }
}

struct ErrorModelMock: Decodable {
    let someUnexpectedResponse: String
}
