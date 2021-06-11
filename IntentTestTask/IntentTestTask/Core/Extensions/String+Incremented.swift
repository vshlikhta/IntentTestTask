//
//  String+incremented.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 11.06.2021.
//

import Foundation

extension String {
    var incremented: String {
        return "\((Int(self) ?? 0) + 1)"
    }
}
