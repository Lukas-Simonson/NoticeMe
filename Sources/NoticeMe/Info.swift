//
//  NoticeInfo.swift
//  
//
//  Created by Lukas Simonson on 3/30/24.
//

import SwiftUI

public struct NoticeInfo: Identifiable {
    public let id: UUID
    public let alignment: Alignment
    public let transition: AnyTransition
    
    internal let presentation: Presentation
    
    public init(id: UUID = UUID(), alignment: Alignment, transition: AnyTransition) {
        self.id = id
        self.alignment = alignment
        self.presentation = .untilCancellation
        self.transition = transition
    }
    
    public init(id: UUID = UUID(), alignment: Alignment, duration: Duration, transition: AnyTransition) {
        self.id = id
        self.alignment = alignment
        self.presentation = .duration(duration)
        self.transition = transition
    }
    
    internal enum Presentation {
        case duration(Duration)
        case untilCancellation
    }
}
