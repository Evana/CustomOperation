//
//  CustomOperation.swift
//
//  Created by Evana Islam on 4/30/17.
//  Copyright © 2017 Evana Islam. All rights reserved.
//

import UIKit

class CustomOperation: Operation {
    
    private let stateLock = NSLock()
    
    private var rawState: OperationState = .ready
    
    var state: OperationState {
        get {
            return stateLock.withCriticalScope{ rawState }
        }
        
        set {
            let arr = [rawState, newValue]
            
            let notifyExecuting = arr.contains(.executing)
            let notifyFinished = arr.contains(.finished)
            
            if notifyExecuting { self.willChangeValue(forKey: KVOKeys.isExecuting)}
            if notifyFinished { self.willChangeValue(forKey: KVOKeys.isFinished)}

            stateLock.withCriticalScope {
                rawState = newValue
            }
            
            if notifyExecuting { self.didChangeValue(forKey: KVOKeys.isExecuting)}
            if notifyFinished { self.didChangeValue(forKey: KVOKeys.isFinished)}
        }
    }
    
    override var isAsynchronous: Bool { return true }

    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }

    override func start() {
        
        if isCancelled { state = .finished}
        if isFinished { return }
        
        state = .executing
        main()
    }
    
    override func main() {
        if self.isCancelled {
            state = .finished
            return
        } else {
            
            //Implement your code
        }
    }
}

extension DownloadOperation {
    
    fileprivate struct KVOKeys {
        static let isReady: String = "isReady"
        static let isExecuting: String = "isExecuting"
        static let isFinished: String = "isFinished"
    }
    enum OperationState {
        case ready, executing, finished
    }
}

