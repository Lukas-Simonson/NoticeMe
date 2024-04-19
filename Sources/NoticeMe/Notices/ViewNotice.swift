//
//  SwiftUIView.swift
//  
//
//  Created by Lukas Simonson on 3/30/24.
//

import SwiftUI

internal struct ViewNotice<V: View>: View, Noticeable {
    
    public var noticeInfo: NoticeInfo
    
    public var body: V
}

public extension AnyNotice {
    /// A `Notice` that uses a custom created View.
    @available(iOS 16, *)
    static func view<V: View>(
        alignment: Alignment,
        duration: Duration,
        transition: AnyTransition,
        @ViewBuilder body: () -> V
    ) -> AnyNotice {
        return AnyNotice(ViewNotice(noticeInfo: NoticeInfo(alignment: alignment, duration: duration, transition: transition), body: body()))
    }
    
    /// A `Notice` that uses a custom created View.
    @available(iOS 16, *)
    static func view<V: View>(
        alignment: Alignment,
        duration: Duration,
        transition: AnyTransition,
        body: V
    ) -> AnyNotice {
        return AnyNotice(ViewNotice(noticeInfo: NoticeInfo(alignment: alignment, duration: duration, transition: transition), body: body))
    }
    
    /// A `Notice` that uses a custom created View.
    @available(iOS, deprecated: 16, renamed: "view(alignment:duration:transition:body:)")
    static func view<V: View>(
        alignment: Alignment,
        lasting time: NoticeInfo.Time,
        transition: AnyTransition,
        @ViewBuilder body: () -> V
    ) -> AnyNotice {
        return AnyNotice(ViewNotice(noticeInfo: NoticeInfo(alignment: alignment, lasting: time, transition: transition), body: body()))
    }
    
    /// A `Notice` that uses a custom created View.
    @available(iOS, deprecated: 16, renamed: "view(alignment:duration:transition:body:)")
    static func view<V: View>(
        alignment: Alignment,
        lasting time: NoticeInfo.Time,
        transition: AnyTransition,
        body:  V
    ) -> AnyNotice {
        return AnyNotice(ViewNotice(noticeInfo: NoticeInfo(alignment: alignment, lasting: time, transition: transition), body: body))
    }
}

//#Preview {
//    SwiftUIView()
//}
