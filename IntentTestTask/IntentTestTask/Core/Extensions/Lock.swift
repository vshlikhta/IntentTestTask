//
//  Lock.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import Foundation

protocol Lock {
    func lock()
    func unlock()
}

// https://cocoawithlove.com/blog/2016/06/02/threads-and-mutexes.html
// http://www.vadimbulavin.com/atomic-properties/
// https://stackoverflow.com/a/47345863/976628
final class Mutex: Lock {
    private var mutex: pthread_mutex_t = {
        var mutex = pthread_mutex_t()
        pthread_mutex_init(&mutex, nil)
        return mutex
    }()
    
    func lock() {
        pthread_mutex_lock(&mutex)
    }
    
    func unlock() {
        pthread_mutex_unlock(&mutex)
    }
}
