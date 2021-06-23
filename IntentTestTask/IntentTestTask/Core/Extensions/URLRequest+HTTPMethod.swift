//
//  URLRequest+HTTPMethod.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 23.06.2021.
//

import Foundation

extension URLRequest {
    mutating func set(_ httpMethod: HTTPMethod) {
        self.httpMethod = httpMethod.rawValue
    }
    
    mutating func addAcceptHeader() {
        self.addValue("application/json", forHTTPHeaderField: "Accept")
    }
}
