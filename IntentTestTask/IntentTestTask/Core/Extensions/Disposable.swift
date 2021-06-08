//
//  Disposable.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

typealias Disposal = [Disposable]

final class Disposable {
    
    private let dispose: () -> ()
    
    init(_ dispose: @escaping () -> ()) {
        self.dispose = dispose
    }
    
    deinit {
        dispose()
    }
    
    public func add(to disposal: inout Disposal) {
        disposal.append(self)
    }
}
