//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/3/23.
//

import Foundation

internal actor NoticeQueue {
    private var queue: [any Notice] = []
    
    internal func peek() -> (any Notice)? {
        return queue.first
    }
    
    @discardableResult
    internal func popQueue() -> (any Notice)? {
        return queue.removeFirst()
    }
    
    internal func addToQueue(_ notice: any Notice) {
        queue.append(notice)
    }
    
    internal func addToFrontOfQueue(_ notice: any Notice) {
        queue.insert(notice, at: 0)
    }
}
