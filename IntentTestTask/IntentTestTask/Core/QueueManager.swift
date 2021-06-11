//
//  QueueManager.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

final class QueueManager {
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .background
        return queue
    }()
    
    static let shared = QueueManager()
    
    func enqueue(_ operation: Operation) {
        queue.addOperation(operation)
    }
    
    func addOperations(_ operations: [Operation]) {
        queue.addOperations(operations, waitUntilFinished: false)
    }
    
    func cancelAllOperations() {
        queue.cancelAllOperations()
    }
}
