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
    @Published private(set) var notice: (any Notice)?
    
    /// The current queue of notices to be displayed.
    private var queue: [any Notice] = [] {
        
        // Starts playing the queue when a Notice is added to an empty queue.
        didSet { if oldValue.isEmpty && !queue.isEmpty { showNextNotice() } }
    }
    
    /// Adds a new `Notice` to the current queue.
    ///
    /// - Note: You can choose to put the passed `Notice` at the start of the queue by setting the urgent
    /// parameter to true.
    ///
    /// Parameters:
    ///  - notice: The `Notice` to display.
    ///  - urgent: A bool controlling where to place the new `Notice` in the current queue.
    public func queueNotice(_ notice: any Notice, urgent: Bool = false) {
        if !urgent { queue.append(notice) }
        else { queue.insert(notice, at: 0) }
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
    
    /// Function to recursivly update the managers current `Notice` to the first item of the queue.
    ///
    /// Recursivly runs until the queue is empty. Handles the duration of how long a `Notice` should
    /// be displayed.
    private func showNextNotice() {
        Task {
            await MainActor.run { notice = queue.first! }
            try? await Task.sleep(nanoseconds: UInt64(notice!.durationSeconds * 1_000_000_000))
            await MainActor.run { notice = nil }
            try? await Task.sleep(nanoseconds: 500_000_000)
            queue.removeFirst()
            if !queue.isEmpty { showNextNotice() }
        }
    }
}

/// A Property Wrapper to give access to the nearest `NoticeManager` through the environment.
@propertyWrapper public struct NoticeMe: DynamicProperty {
    
    @Environment(\.noticeManager) var manager
    
    public init() {}
    
    public var wrappedValue: NoticeManager {
        guard let manager
        else { fatalError("No Notice Handler Found. Are you using a NoticeManager in you View Hierarchy?") }
        return manager
    }
}

private struct NoticeManagerKey: EnvironmentKey {
    static let defaultValue: NoticeManager? = nil
}

internal extension EnvironmentValues {
    var noticeManager: NoticeManager? {
        get { self[NoticeManagerKey.self] }
        set { self[NoticeManagerKey.self] = newValue }
    }
}
