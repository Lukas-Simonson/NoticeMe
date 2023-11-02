//
//  SwiftUIView.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

internal struct Snackbar: Notice {

    public var id = UUID()
    public var alignment: Alignment = .bottom
    public var durationSeconds: Double = 2.0
    public var transition: AnyTransition = .move(edge: .bottom)
    
    private var message: String
    private var textColor: Color
    private var backgroundColor: Color
    
    internal init(
        _ message: String,
        durationSeconds: Double = 2.0,
        textColor: Color = .white,
        backgroundColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25)
    ) {
        self.message = message
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        Text(message)
            .font(.headline)
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
    }
}

#Preview {
    ZStack {
        Snackbar("Hello, World")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
