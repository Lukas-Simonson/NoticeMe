//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

public struct NoticeHandler<Content: View>: View {
    
    @StateObject private var manager = NoticeManager()
    
    private var content: () -> Content
    
    public init(content: @escaping () -> Content) {
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
