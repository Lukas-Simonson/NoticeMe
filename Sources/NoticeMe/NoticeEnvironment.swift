//
//  NoticeCancellation.swift
//  NoticeMe
//
//  Created by Lukas Simonson on 10/23/24.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var noticeManager: NoticeManager? = nil
    @Entry var noticeCancellation: NoticeInfo.Cancellation = NoticeInfo.Cancellation {  }
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

/// A Property Wrapper to give access to a Notices cancellation, causing the notice to stop displaying.
///
/// > Note: This property wrapper will only work inside of a `Noticeable` struct, using it in any other context will result in nothing happening.
///
@propertyWrapper public struct NoticeCancellation: DynamicProperty {
    
    public typealias Cancellation = () -> Void
    
    @Environment(\.noticeCancellation) var cancellation
    
    public init() {}
    
    public var wrappedValue: NoticeInfo.Cancellation {
        cancellation
    }
}
