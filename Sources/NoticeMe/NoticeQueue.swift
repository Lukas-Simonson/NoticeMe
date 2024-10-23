//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/3/23.
//

import Foundation

internal actor NoticeQueue {
    private var queue: [any Noticeable] = []
    
    @discardableResult
    internal func dequeue() -> (any Noticeable)? {
        if !queue.isEmpty {
            return queue.removeFirst()
        } else {
            return nil
        }
    }
    
    internal func enqueue(_ notice: any Noticeable) {
        queue.append(notice)
    }
    
    internal func priorityEnqueue(_ notice: any Noticeable) {
        queue.insert(notice, at: 0)
    }
}
