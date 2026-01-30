//
//  NoticeHandler.swift
//
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

public extension View {
    
    /// A modifier that handles the presentation of `Notice`s into the UI.
    ///
    /// This modifier is typically attached to the root of your `WindowGroup` so that all `Notice`s sent to the UI
    /// can be handled from the same source.
    ///
    /// - Note: A NoticeHandler is required above any views that would show notices in the View hierarchy.
    ///
    /// Parameters:
    ///  - manager: The `NoticeManager` to use for notices. When none are provided a new one is created.
    func handleNotices(from manager: NoticeManager?) -> some View {
        modifier(NoticeHandler(manager: manager ?? NoticeManager()))
    }
}

private struct NoticeHandler: ViewModifier {
    
    @State private var manager: NoticeManager
    
    init(manager: NoticeManager) {
        self.manager = manager
    }
    
    func body(content: Content) -> some View {
        content
            .environment(\.noticeManager, manager)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: manager.notice?.alignment ?? .center) {
                ZStack {
                    if let notice = manager.notice, let cancellation = manager.cancellation {
                        AnyView(notice)
                            .environment(\.noticeCancellation, cancellation)
                            .transition(notice.transition)
                            .id(notice.id)
                    }
                }
                .animation(.easeInOut, value: manager.notice?.id)
            }
    }
}
