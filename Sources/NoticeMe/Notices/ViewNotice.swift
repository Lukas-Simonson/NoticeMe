//
//  ViewNotice.swift
//  
//
//  Created by Lukas Simonson on 3/30/24.
//

import SwiftUI

public struct ViewNotice: Noticeable {
    public var noticeInfo: NoticeInfo
    public var body: AnyView
}

extension Noticeable where Self == ViewNotice {
    static func view(
        alignment: Alignment,
        duration: Duration,
        transition: AnyTransition,
        @ViewBuilder body: () -> some View
    ) -> ViewNotice {
        ViewNotice(noticeInfo: NoticeInfo(alignment: alignment, duration: duration, transition: transition), body: AnyView(body()))
    }
}
