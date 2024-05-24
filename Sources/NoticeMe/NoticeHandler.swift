//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

/// A View in charge of handling the presentation of `Notice`s into the UI.
///
/// This View is typically placed in the root of your `WindowGroup` so that all `Notice`s sent to the UI
/// can be handled from the same source.
///
/// - Note: A NoticeHandler is required above any views that show notices in the View hierarcy.
///
public struct NoticeHandler<Content: View>: View {
    
    /// The manager to be used by this `NoticeHandler`.
    @StateObject private var manager = NoticeManager()
    
    /// The child views that can send notifications.
    private var content: () -> Content
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    
    public init(_ manager: NoticeManager, content: @escaping () -> Content) {
        self._manager = StateObject(wrappedValue: manager)
        self.content = content
    }
    
    public var body: some View {
        content()
            .environment(\.noticeManager, manager)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: manager.notice?.alignment ?? .center) {
                ZStack {
                    if let notice = manager.notice {
                        AnyView(notice)
                            .transition(notice.transition)
                            .id(notice.id)
                    }
                }
                .animation(.easeInOut, value: manager.notice?.id)
            }
    }
}
