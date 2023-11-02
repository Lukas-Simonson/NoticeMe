//
//  SwiftUIView.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

internal struct Patch: Notice {
    
    public var id: UUID = UUID()
    public var alignment: Alignment = .center
    public var durationSeconds: Double
    public var transition: AnyTransition = .scale
    
    private var title: String
    private var systemIcon: String
    private var iconColor: Color
    
    internal init(
        _ title: String,
        systemIcon: String,
        iconColor: Color = .black,
        durationSeconds: Double = 2.0
    ) {
        self.title = title
        self.systemIcon = systemIcon
        self.iconColor = iconColor
        self.durationSeconds = durationSeconds
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 200)
            .overlay(alignment: .center) {
                VStack {
                    Image(systemName: systemIcon)
                        .resizable()
                        .padding()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 100)
                        .foregroundStyle(iconColor)
                    
                    Text(title)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
    }
}

#Preview {
    Patch("Error", systemIcon: "xmark", iconColor: .pink)
}
