//
//  NetworkRequestOperation.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

class NetworkOperation: Operation {
    typealias OperationCompletionHandler = (_ result: Result<Data, Error>) -> Void
    
    var completionHandler: (OperationCompletionHandler)?
    
    private enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }
    
    private var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        guard isCancelled == false else {
            finish()
            return
        }
        if isExecuting == false {
            state = .executing
        }
        main()
    }
    
    func finish() {
        guard isExecuting else { return }
        state = .finished
    }
    
    func complete(result: Result<Data, Error>) {
        finish()
        if isCancelled == false {
            completionHandler?(result)
        }
    }
    
    override func cancel() {
        super.cancel()
        finish()
    }
}
