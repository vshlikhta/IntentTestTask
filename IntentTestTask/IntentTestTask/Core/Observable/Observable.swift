//
//  Observable.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

class ImmutableObservable<T> {
    
    public typealias Observer = (T, T?) -> Void
    
    private var observers: [Int: (Observer, DispatchQueue?)] = [:]
    private var uniqueID = (0...).makeIterator()
    
    fileprivate let lock: Lock = Mutex()
    
    fileprivate var _value: T {
        didSet {
            let newValue = _value
            observers.values.forEach { observer, dispatchQueue in
                if let dispatchQueue = dispatchQueue {
                    dispatchQueue.async {
                        observer(newValue, oldValue)
                    }
                } else {
                    observer(newValue, oldValue)
                }
            }
        }
    }
    
    public var value: T {
        return _value
    }
    
    fileprivate var _onDispose: () -> Void
    
    public init(_ value: T, onDispose: @escaping () -> Void = {}) {
        self._value = value
        self._onDispose = onDispose
    }
    
    public func observe(_ queue: DispatchQueue? = nil, with observer: @escaping Observer) -> Disposable {
        lock.lock()
        defer { lock.unlock() }
        
        let id = uniqueID.next()!
        
        observers[id] = (observer, queue)
        observer(value, nil)
        
        let disposable = Disposable { [weak self] in
            self?.observers[id] = nil
            self?._onDispose()
        }
        
        return disposable
    }
    
    public func removeAllObservers() {
        observers.removeAll()
    }
    
    public var immutable: ImmutableObservable<T> {
        return self
    }
}

class Observable<T>: ImmutableObservable<T> {
    
    public override var value: T {
        get {
            return _value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
}
