//
//  Constants.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation
import UIKit

struct Constants {
    struct Github {
        static let scheme: String = "https"
        static let host: String = "api.github.com"
        static let defaultPage: String = "1"
    }
    
    static let baseURL: String = "https://api.github.com/search/repositories"
    
    struct RepositoryList {
        struct UI {
            static let defaultRowHeight: CGFloat = 200
        }
    }
}
