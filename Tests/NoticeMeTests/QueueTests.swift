//
//  QueueTests.swift
//  NoticeMe
//
//  Created by Lukas Simonson on 1/30/26.
//

import Testing
@testable import NoticeMe

@Suite("Queue Tests")
struct QueueTests {

    // MARK: - Enqueue

    @Test
    func `Enqueued item is last in queue`() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)

        #expect(queue.dequeue() == 1)
        #expect(queue.dequeue() == 2)
        #expect(queue.dequeue() == 3)
    }

    @Test
    func `Enqueue increases count`() {
        var queue = Queue<Int>()
        #expect(queue.count == 0)

        queue.enqueue(10)
        #expect(queue.count == 1)

        queue.enqueue(20)
        #expect(queue.count == 2)
    }

    @Test
    func `Enqueue to empty queue sets front`() {
        var queue = Queue<String>()
        queue.enqueue("first")
        #expect(queue.front == "first")
    }

    @Test
    func `Enqueue does not change front when queue is non-empty`() {
        var queue = Queue<String>()
        queue.enqueue("first")
        queue.enqueue("second")
        #expect(queue.front == "first")
    }

    // MARK: - Dequeue

    @Test
    func `Dequeue returns items in FIFO order`() {
        var queue = Queue<String>()
        queue.enqueue("a")
        queue.enqueue("b")
        queue.enqueue("c")

        #expect(queue.dequeue() == "a")
        #expect(queue.dequeue() == "b")
        #expect(queue.dequeue() == "c")
    }

    @Test
    func `Dequeue from empty queue returns nil`() {
        var queue = Queue<Int>()
        #expect(queue.dequeue() == nil)
    }

    @Test
    func `Dequeue decreases count`() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        #expect(queue.count == 2)

        _ = queue.dequeue()
        #expect(queue.count == 1)

        _ = queue.dequeue()
        #expect(queue.count == 0)
    }

    @Test
    func `Dequeue updates front to next item`() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)

        _ = queue.dequeue()
        #expect(queue.front == 2)
    }

    @Test
    func `Dequeue all items makes queue empty`() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)

        _ = queue.dequeue()
        _ = queue.dequeue()

        #expect(queue.isEmpty)
        #expect(queue.front == nil)
    }

    // MARK: - Priority Enqueue

    @Test
    func `Priority enqueue places item at front of queue`() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.priorityEnqueue(99)

        #expect(queue.front == 99)
        #expect(queue.dequeue() == 99)
    }

    @Test
    func `Priority enqeue on empty queue works`() {
        var queue = Queue<Int>()
        queue.priorityEnqueue(42)

        #expect(queue.count == 1)
        #expect(queue.front == 42)
        #expect(queue.dequeue() == 42)
    }

    @Test
    func `Priority enqueue preserves existing items behind it`() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)
        queue.priorityEnqueue(0)

        #expect(queue.dequeue() == 0)
        #expect(queue.dequeue() == 1)
        #expect(queue.dequeue() == 2)
        #expect(queue.dequeue() == 3)
    }

    @Test
    func `Priority enqueue increases count`() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        #expect(queue.count == 1)

        queue.priorityEnqueue(2)
        #expect(queue.count == 2)
    }

    @Test
    func `Multiple priority enqueues maintain last-priority-first order`() {
        var queue = Queue<String>()
        queue.enqueue("normal")
        queue.priorityEnqueue("priority1")
        queue.priorityEnqueue("priority2")

        #expect(queue.dequeue() == "priority2")
        #expect(queue.dequeue() == "priority1")
        #expect(queue.dequeue() == "normal")
    }

    @Test
    func `Priority enqueue after dequeue places item at front`() {
        var queue = Queue<Int>()
        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)

        _ = queue.dequeue() // remove 1

        queue.priorityEnqueue(99)

        #expect(queue.dequeue() == 99)
        #expect(queue.dequeue() == 2)
        #expect(queue.dequeue() == 3)
    }
}
