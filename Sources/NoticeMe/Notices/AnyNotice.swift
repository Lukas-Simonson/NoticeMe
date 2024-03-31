//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

/// A type-erased `Notice`
public struct AnyNotice {
    internal var notice: any Noticeable
    
    init<N: Noticeable>(_ notice: N) {
        self.notice = notice
    }
}
