//
//  RepositoryRequest.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 11.06.2021.
//

import Foundation

enum RepositoryRequest {
    
    case repositoryList(query: String?, page: String)
    
    func getMutableRequest() throws -> URLRequest {
        var baseComponents = IntentTestTaskRequest.components(path: self.path)
        try addQueryItems(to: &baseComponents)
        
        guard let url = baseComponents.url else {
            throw IntentTestTaskError.Internal.badURL
        }
        
        var request = URLRequest(url: url)
        request.set(httpMethod)
        
        request.addAcceptHeader()
        
        return request
    }
    
    private var path: String {
        switch self {
        case .repositoryList:
            return "/search/repositories"
        }
    }
    
    private var httpMethod: HTTPMethod {
        switch self {
        case .repositoryList:
            return .GET
        }
    }
    
    private func addQueryItems(to components: inout URLComponents) throws {
        switch self {
        case .repositoryList(let query, let page):
            components.queryItems = [URLQueryItem(name: "q", value: query),
                                     URLQueryItem(name: "page", value: page)]
        }
    }
}

enum IntentTestTaskRequest {
    
    static var components: URLComponents {
        var components = URLComponents()
        components.scheme = Constants.Github.scheme
        components.host = Constants.Github.host
        
        return components
    }
    
    static func components(path: String) -> URLComponents {
        var componentsWithPath = components
        componentsWithPath.path = path
        return componentsWithPath
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

extension URLRequest {
    mutating func set(_ httpMethod: HTTPMethod) {
        self.httpMethod = httpMethod.rawValue
    }
    
    mutating func addAcceptHeader() {
        self.addValue("application/json", forHTTPHeaderField: "Accept")
    }
}
