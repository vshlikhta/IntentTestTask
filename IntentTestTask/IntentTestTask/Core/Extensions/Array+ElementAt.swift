//
//  Array+ElementAt.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 11.06.2021.
//

import Foundation

extension Array {
    func element(at index: Int) -> Element? {
        return enumerated().first { $0.offset == index }?.element
    }
}
