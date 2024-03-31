//
//  SwiftUIView.swift
//
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

internal struct Toast: Noticeable {
    
    public var noticeInfo: NoticeInfo
    
    private var title: String
    private var message: String?
    private var systemIcon: String?
    private var textColor: Color
    private var systemIconColor: Color
    private var backgroundColor: Color
    
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

extension Toast {
    internal init(
        _ title: String,
        message: String? = nil,
        systemIcon: String? = nil,
        lasting time: NoticeInfo.Time,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white,
        alignment: Alignment = .bottom
    ) {
        self.title = title
        self.message = message
        self.systemIcon = systemIcon
        self.textColor = textColor
        self.systemIconColor = systemIconColor
        self.backgroundColor = backgroundColor
        
        let transition : AnyTransition = if #available(iOS 16.0, *) { .asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)) }
        else { .move(edge: .bottom) }
        
        self.noticeInfo = NoticeInfo(
            alignment: .bottom,
            lasting: time,
            transition: transition
        )
    }
    
    @available(iOS 16, *)
    internal init(
        _ title: String,
        message: String? = nil,
        systemIcon: String? = nil,
        duration: Duration,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white,
        alignment: Alignment = .bottom
    ) {
        self.title = title
        self.message = message
        self.systemIcon = systemIcon
        self.textColor = textColor
        self.systemIconColor = systemIconColor
        self.backgroundColor = backgroundColor
        
        let transition : AnyTransition = if #available(iOS 16.0, *) { .asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)) }
        else { .move(edge: .bottom) }
        
        self.noticeInfo = NoticeInfo(
            alignment: .bottom,
            duration: duration,
            transition: transition
        )
    }
}

#Preview {
    ZStack {
        Toast("Hello, World", message: "How Are You?", systemIcon: "pencil.circle.fill", lasting: .seconds(2))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
