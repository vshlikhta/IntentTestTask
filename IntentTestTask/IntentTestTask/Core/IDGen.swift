//
//  IDGen.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

public final class IDGen {
    
    static func `default`() -> String {
        let bundleID = Bundle(for: IDGen.self).bundleIdentifier!.lowercased()
        return "\(bundleID).sample"
    }
    
    static func makeID(from value: String) -> String {
        return "\(IDGen.default()).\(value)"
    }
    
}
