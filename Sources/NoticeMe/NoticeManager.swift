//
//  SwiftUIView.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

/// A Class that manages the order and speed at which `Notice`s are given to an Observing `View`.
public class NoticeManager: ObservableObject {
    
    /// The current notice that should be displayed by an Observing `View`.
    @Published private(set) var notice: (any Noticeable)?
    
    /// A closure that when called, will stop displaying the current notice.
    private(set) var cancellation: NoticeInfo.Cancellation?
    
    /// The current queue of notices to be displayed.
    private var queue = NoticeQueue()
    
    private var noticeLoop: Task<Void, Never>?
    
    public init() { }
    
    /// Adds a new `Notice` to the current queue. Waiting for the notice to be added.
    ///
    /// - Note: You can choose to put the passed `Notice` at the start of the queue by setting the urgent
    /// parameter to true.
    ///
    /// Parameters:
    ///  - notice: The `Notice` to display.
    ///  - urgent: A bool controlling where to place the new `Notice` in the current queue.
    public func queueNotice(_ notice: any Noticeable, urgent: Bool = false) async {
        if urgent { await queue.priorityEnqueue(notice) }
        else { await queue.enqueue(notice) }
        showNotice()
    }
    
    /// Adds a new `Notice` to the current queue.
    ///
    /// - Note: You can choose to put the passed `Notice` at the start of the queue by setting the urgent
    /// parameter to true.
    ///
    /// Parameters:
    ///  - notice: The `Notice` to display.
    ///  - urgent: A bool controlling where to place the new `Notice` in the current queue.
    public func queueNotice(_ notice: any Noticeable, urgent: Bool = false) {
        Task {
            await queueNotice(notice, urgent: urgent)
            print("Notice Queued")
        }
    }
    
    /// Adds a new `Notice` to the current queue. Waiting for the notice to be added.
    ///
    /// - Note: You can choose to put the passed `Notice` at the start of the queue by setting the urgent
    /// parameter to true.
    ///
    /// Parameters:
    ///  - notice: The `Notice` to display.
    ///  - urgent: A bool controlling where to place the new `Notice` in the current queue.
    public func queueNotice(_ notice: AnyNotice, urgent: Bool = false) async {
        await queueNotice(notice.notice, urgent: urgent)
    }
    
    /// Adds a new `Notice` to the current queue.
    ///
    /// - Note: You can choose to put the passed `Notice` at the start of the queue by setting the urgent
    /// parameter to true.
    ///
    /// Parameters:
    ///  - notice: The `Notice` to display.
    ///  - urgent: A bool controlling where to place the new `Notice` in the current queue.
    public func queueNotice(_ notice: AnyNotice, urgent: Bool = false) {
        queueNotice(notice.notice, urgent: urgent)
    }
    
    /// Function to recursively update the managers current `Notice` to the first item of the queue.
    ///
    /// Recursively runs until the queue is empty. Handles the duration of how long a `Notice` should
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
        
        // Make sure no loop is currently running.
        guard noticeLoop == nil
        else { return }
        
        noticeLoop = Task {
            // When current loop runs out of notices, destroy loop.
            defer { noticeLoop = nil }
            
            // Loop Until No Notices Are Available.
            while let notice = await queue.dequeue() {
                
                // Handle Different Presentation Modes
                switch notice.presentation {
                    case .duration(let nano):
                        // Create Task To Await Duration
                        let durationTask = Task { try? await Task.sleep(nanoseconds: nano) }
                        
                        await MainActor.run {
                            // MARK: Cancellation MUST be set BEFORE notice.
                            // Set cancellation to cancel the duration task.
                            self.cancellation = NoticeInfo.Cancellation { durationTask.cancel() }
                            self.notice = notice
                        }

                        // Await Completion of durationTask
                        _ = await durationTask.value
                    
                    case .untilCancellation:
                        // Use a continuation to handle cancellation.
                        await withCheckedContinuation(isolation: MainActor.shared) { continuation in
                            // MARK: Cancellation MUST Be Set BEFORE notice.
                            cancellation = NoticeInfo.Cancellation { continuation.resume() }
                            self.notice = notice
                        }
                }
                
                // Clear Notice And Cancellation
                await MainActor.run {
                    self.cancellation = nil
                    self.notice = nil
                }
                
                // Wait Between Showing Notices
                try? await Task.sleep(nanoseconds: 500_000_000)
            }
        }
    }
}
