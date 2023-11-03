//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

/// Protocol representing a Notice that can be sent through the `NoticeMe.NoticeManager`
public protocol Notice: View, Identifiable {
    
    /// Unique identifier for a given `Notice`.
    var id: UUID { get }
    
    /// Where on the screen the `Notice` can appear.
    var alignment: Alignment { get }
    
    /// How long, in seconds, the `Notice` should be on screen.
    var durationSeconds: Double { get }
    
    /// Which transition should be used for transitioning the `Notice` on and off screen.
    var transition: AnyTransition { get }
}
