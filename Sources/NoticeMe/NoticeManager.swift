//
//  SwiftUIView.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

public class NoticeManager: ObservableObject {
    
    @Published private(set) var notice: (any Notice)?
    private var queue: [any Notice] = [] {
        didSet { if oldValue.isEmpty && !queue.isEmpty { showNextNotice() } }
    }
    
    public func queueNotice(_ notice: any Notice, urgent: Bool = false) {
        if !urgent { queue.append(notice) }
        else { queue.insert(notice, at: 0) }
    }
    
    public func queueNotice(_ notice: AnyNotice, urgent: Bool = false) {
        queueNotice(notice.notice, urgent: urgent)
    }
    
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

private struct NoticeManagerKey: EnvironmentKey {
    static let defaultValue: NoticeManager? = nil
}

internal extension EnvironmentValues {
    var noticeManager: NoticeManager? {
        get { self[NoticeManagerKey.self] }
        set { self[NoticeManagerKey.self] = newValue }
    }
}

@propertyWrapper public struct NoticeMe: DynamicProperty {
    
    @Environment(\.noticeManager) var manager
    
    public init() {}
    
    public var wrappedValue: NoticeManager {
        guard let manager
        else { fatalError("No Notice Handler Found. Are you using a NoticeManager in you View Hierarchy?") }
        return manager
    }
}
