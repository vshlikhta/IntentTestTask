//
//  IntentTestTaskAlert.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 22.06.2021.
//

import Foundation

enum IntentTestTaskAlert {
    case generic
    case custom(title: String, description: String)
    
    var title: String {
        switch self {
        case .generic:
            return "Oops!"
        case .custom(let title, _):
            return title
        }
    }
    
    var message: String {
        switch self {
        case .generic:
            return "Something went wrong"
        case .custom(_, let description):
            return description
        }
    }
}
