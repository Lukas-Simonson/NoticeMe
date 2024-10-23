//
//  File.swift
//  
//
//  Created by Lukas Simonson on 3/30/24.
//

import SwiftUI

public struct NoticeInfo: Identifiable {
    public let id: UUID
    public let alignment: Alignment
    public let presentation: Presentation
    public var transition: AnyTransition
    
    public init(alignment: Alignment, transition: AnyTransition) {
        self.id = UUID()
        self.alignment = alignment
        self.presentation = .untilCancellation
        self.transition = transition
    }
    
    @available(iOS, deprecated: 16, message: "init(alignment:duration:transition:)")
    public init(alignment: Alignment, lasting: Time, transition: AnyTransition) {
        self.id = UUID()
        self.alignment = alignment
        self.presentation = .duration(nano: lasting.nanoseconds)
        self.transition = transition
    }
    
    @available(iOS 16, *)
    public init(alignment: Alignment, duration: Duration, transition: AnyTransition) {
        self.id = UUID()
        self.alignment = alignment
        self.presentation = .duration(nano: duration.nanoseconds)
        self.transition = transition
    }
    
    @available(iOS, deprecated: 16)
    public enum Time {
        case seconds(Int)
        case milliseconds(Int)
        case nanoseconds(Int)
        
        var nanoseconds: UInt64 {
            switch self {
                case .seconds(let seconds): return UInt64(seconds) * 1_000_000_000
                case .milliseconds(let milli): return UInt64(milli) * 10_00_000
                case .nanoseconds(let nano): return UInt64(nano)
            }
        }
    }
    
    public enum Presentation {
        case duration(nano: UInt64)
        case untilCancellation
    }
}

@available(iOS 16, *)
extension Duration {
    var nanoseconds: UInt64 {
        let secondsInNanoseconds = UInt64(self.components.seconds) * 1_000_000_000
        let attosecondsInNanoseconds = UInt64(self.components.attoseconds) / 1_000_000_000
        return secondsInNanoseconds + attosecondsInNanoseconds
    }
}
