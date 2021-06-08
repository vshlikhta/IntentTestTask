//
//  IntentTestTaskError.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

enum IntentTestTaskError: Error {
    
    case general
    
    enum Internal: Error {
        case badURL
    }
}
