//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

/// Protocol representing a Notice that can be sent through the `NoticeMe.NoticeManager`
public protocol Noticeable: View {
    var noticeInfo: NoticeInfo { get }
}

internal extension Noticeable {
    var id: UUID { noticeInfo.id }
    var alignment: Alignment { noticeInfo.alignment }
    var presentation: NoticeInfo.Presentation { noticeInfo.presentation }
    var transition: AnyTransition { noticeInfo.transition }
}
