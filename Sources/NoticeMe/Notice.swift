//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

public protocol Notice: View, Identifiable {
    var id: UUID { get }
    var alignment: Alignment { get }
    var durationSeconds: Double { get }
    var transition: AnyTransition { get }
}
