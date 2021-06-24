//
//  Int+AsIndex.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 24.06.2021.
//

import Foundation

extension Int {
    var asIndex: Int {
        return self <= 0 ? 0 : self - 1
    }
}
