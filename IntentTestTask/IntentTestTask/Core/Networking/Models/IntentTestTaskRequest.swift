//
//  IntentTestTaskRequest.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 23.06.2021.
//

import Foundation

struct IntentTestTaskRequest {
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
