//
//  SwiftUIView.swift
//
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

internal struct Toast: Notice {
    
    public var id = UUID()
    public var alignment: Alignment = .bottom
    public var durationSeconds: Double = 2.0
    
    public var transition: AnyTransition =
    if #available(iOS 16.0, *) { .asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)) }
    else { .move(edge: .bottom) }
    
    private var title: String
    private var message: String?
    private var systemIcon: String?
    private var textColor: Color
    private var systemIconColor: Color
    private var backgroundColor: Color
    
    internal init(
        _ title: String,
        message: String? = nil,
        systemIcon: String? = nil,
        durationSeconds: Double = 2.0,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white,
        alignment: Alignment = .bottom
    ) {
        self.title = title
        self.message = message
        self.systemIcon = systemIcon
        self.durationSeconds = durationSeconds
        self.textColor = textColor
        self.systemIconColor = systemIconColor
        self.backgroundColor = backgroundColor
        self.alignment = alignment
    }
    
    @State private var imageHeight: CGFloat = .zero
    
    public var body: some View {
        HStack {
            if let systemIcon {
                Image(systemName: systemIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(systemIconColor)
                    .frame(maxWidth: imageHeight * 1.5, maxHeight: imageHeight)
            }
            
            VStack(alignment: systemIcon == nil ? .center : .leading) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                
                if let message {
                    Text(message)
                        .font(.caption2)
                }
            }
            .foregroundStyle(textColor)
            .multilineTextAlignment(systemIcon == nil ? .center : .leading)
        }
        .overlay {
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        imageHeight = proxy.size.height * (message == nil ? 1 : 0.85)
                    }
            }
        }
        .padding()
        .background(
            Capsule()
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
        )
        .animation(nil, value: imageHeight)
    }
}

#Preview {
    ZStack {
        Toast("Hello, World", message: "How Are You?", systemIcon: "pencil.circle.fill")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
