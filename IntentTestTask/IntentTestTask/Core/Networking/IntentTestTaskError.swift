//
//  IntentTestTaskError.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

enum IntentTestTaskError: Error {
    
    case general
    case corruptedRequest
    case missingData
    case badStatusCode(value: Int)
    case corruptedData
    case custom(error: Error)
    
    var asAlert: IntentTestTaskAlert {
        switch self {
        case .custom(let error):
            return .custom(title: "Oops!", description: error.localizedDescription)
        case .badStatusCode(let value):
            return .custom(title: "Network request failed", description: "Status code:\(value)")
        default:
            return .generic
        }
    }
    
    enum Internal: Error {
        case badURL
        
        var asAlert: IntentTestTaskAlert {
            return .generic
        }
    }
}
