//
//  NoticeManager.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import Observation

/// Manages a queue of notices.
@MainActor @Observable
public class NoticeManager {
    
    /// The current notice that should be displayed by an observing `View`.
    private(set) var notice: (any Noticeable)?
    
    /// A closure that when called with stop displaying the current notice.
    private(set) var cancellation: NoticeInfo.Cancellation?
    
    /// The current queue of notices to be displayed.
    private var queue = Queue<any Noticeable>()
    
    /// A task that handles updating notices from the queue with a delay.
    private var loop: Task<Void, Never>?
    
    public init() { }
}

extension NoticeManager {
    /// Adds a new `Notice` to the current queue.
    ///
    /// - Note: You can choose to put the passed `Notice` at the start of the queue by setting the urgent
    /// parameter to true.
    ///
    /// Parameters:
    ///  - notice: The `Notice` to display.
    ///  - urgent: A bool controlling where to place the new `Notice` in the current queue.
    public func queueNotice(_ notice: any Noticeable, urgent: Bool = false) {
        if urgent { queue.priorityEnqueue(notice) }
        else { queue.enqueue(notice) }
        
        showNotice()
    }
    
    /// Function to update the managers current `Notice` to the first item of the queue.
    ///
    /// Continuously runs until the queue is empty. Handles the duration of how long a `Notice` should
    /// be displayed.
    ///
    /// - Note: Only one showNotice recursion loop can be running at a time, this is tracked by the
    /// noticeLoop property of the `NoticeManager`.
    ///
    ///
    /// Function to continuously update the managers current `Notice` to the first item of the queue.
    ///
    /// Runs until the queue is empty. Handles the duration of how long a `Notice` should be displayed.
    private func showNotice() {
        guard loop == nil else { return }
        
        loop = Task { @MainActor in
            defer { self.loop = nil }
            
            while let notice = queue.dequeue() {
                switch notice.presentation {
                    case .duration(let duration):
                        let wait = Task { try? await Task.sleep(for: duration) }
                        
                        self.cancellation = NoticeInfo.Cancellation { wait.cancel() }
                        self.notice = notice
                        
                        await wait.value
                    case .untilCancellation:
                        await withCheckedContinuation(isolation: MainActor.shared) { continuation in
                            self.cancellation = NoticeInfo.Cancellation { continuation.resume() }
                            self.notice = notice
                        }
                }
                
                self.cancellation = nil
                self.notice = nil
                
                // Wait between notices
                try? await Task.sleep(for: .milliseconds(500))
            }
        }
    }
}
