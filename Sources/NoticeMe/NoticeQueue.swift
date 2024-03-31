//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/3/23.
//

import Foundation

internal actor NoticeQueue {
    private var queue: [any Noticeable] = []
    
    internal var front: (any Noticeable)? {
        queue.first
    }
    
    @discardableResult
    internal func dequeue() -> (any Noticeable)? {
        return queue.removeFirst()
    }
    
    internal func enqueue(_ notice: any Noticeable) {
        queue.append(notice)
    }
    
    internal func priorityEnqueue(_ notice: any Noticeable) {
        queue.insert(notice, at: 0)
    }
}
