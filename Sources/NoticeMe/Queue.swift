//
//  Queue.swift
//  
//
//  Created by Lukas Simonson on 11/3/23.
//

import Foundation

struct Queue<T> {
    private var storage = [T?]()
    private var head = 0
    
    var count: Int { storage.count - head }
    var isEmpty: Bool { count == 0 }
    var front: T? { isEmpty ? nil : storage[head] }
    
    mutating func enqueue(_ element: T) {
        storage.append(element)
    }
    
    mutating func priorityEnqueue(_ element: T) {
        if head == 0 { storage.insert(element, at: 0) }
        else {
            head -= 1
            storage[head] = element
        }
    }
    
    mutating func dequeue() -> T? {
        guard head < storage.count, let element = storage[head] else { return nil }
        
        storage[head] = nil
        head += 1
        
        let percentage = Double(head) / Double(storage.count)
        if storage.count > 50 && percentage > 0.25 {
            storage.removeFirst(head)
            head = 0
        }
        
        return element
    }
}
