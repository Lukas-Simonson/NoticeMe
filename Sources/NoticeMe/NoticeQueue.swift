//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/3/23.
//

import Foundation

internal actor NoticeQueue {
    private var queue: [any Notice] = []
    
    internal var front: (any Notice)? {
        queue.first
    }
    
    @discardableResult
    internal func dequeue() -> (any Notice)? {
        return queue.removeFirst()
    }
    
    internal func enqueue(_ notice: any Notice) {
        queue.append(notice)
    }
    
    internal func priorityEnqueue(_ notice: any Notice) {
        queue.insert(notice, at: 0)
    }
}
