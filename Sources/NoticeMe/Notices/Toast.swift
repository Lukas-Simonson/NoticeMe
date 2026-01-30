//
//  Toast.swift
//
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

public struct Toast: Noticeable {
    public var noticeInfo: NoticeInfo
    
    private var title: LocalizedStringResource
    private var message: LocalizedStringResource?
    private var systemImage: String?
    
    private var foreground: AnyShapeStyle
    private var background: AnyShapeStyle
    private var imageForeground: AnyShapeStyle
    
    @State private var imageHeight = CGFloat.zero
    
    public var body: some View {
        HStack {
            image
            information
        }
        .overlay(sizeReader)
        .padding()
        .background(backgroundView)
        .animation(nil, value: imageHeight)
    }
    
    @ViewBuilder
    private var image: some View {
        if let systemImage {
            Image(systemName: systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(imageForeground)
                .frame(maxWidth: imageHeight * 1.5, maxHeight: imageHeight)
        }
    }
    
    private var information: some View {
        VStack(alignment: systemImage == nil ? .center : .leading) {
            Text(title)
                .font(.subheadline)
                .bold()
            
            if let message {
                Text(message)
                    .font(.caption2)
            }
        }
        .foregroundStyle(foreground)
        .multilineTextAlignment(systemImage == nil ? .center : .leading)
    }
    
    private var sizeReader: some View {
        GeometryReader { proxy in
            Color.clear.onAppear {
                imageHeight = proxy.size.height * (message == nil ? 1 : 0.85)
            }
        }
    }
    
    private var backgroundView: some View {
        Capsule()
            .fill(background)
            .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
    }
}

public extension Toast {
    init(
        title: LocalizedStringResource,
        message: LocalizedStringResource?,
        systemImage: String?,
        foreground: some ShapeStyle,
        background: some ShapeStyle,
        imageForeground: some ShapeStyle,
        alignment: Alignment = .bottom,
        duration: Duration = .seconds(2),
        transition: AnyTransition = .move(edge: .bottom),
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        
        self.foreground = AnyShapeStyle(foreground)
        self.background = AnyShapeStyle(background)
        self.imageForeground = AnyShapeStyle(imageForeground)
        
        self.noticeInfo = NoticeInfo(
            alignment: alignment,
            duration: duration,
            transition: transition
        )
    }
}

public extension Noticeable where Self == Toast {
    static func toast(
        title: LocalizedStringResource,
        message: LocalizedStringResource? = nil,
        systemImage: String? = nil,
        duration: Duration = .seconds(2),
        foreground: some ShapeStyle = Color.primary,
        background: some ShapeStyle = Material.regular,
        imageForeground: some ShapeStyle = Color.primary,
    ) -> Toast {
        Toast(title: title, message: message, systemImage: systemImage, foreground: foreground, background: background, imageForeground: imageForeground, duration: duration)
    }
    
    static func message(
        title: LocalizedStringResource,
        message: LocalizedStringResource? = nil,
        systemImage: String? = nil,
        duration: Duration = .seconds(2),
        foreground: some ShapeStyle = Color.primary,
        background: some ShapeStyle = Material.regular,
        imageForeground: some ShapeStyle = Color.primary,
    ) -> Toast {
        Toast(
            title: title,
            message: message,
            systemImage: systemImage,
            foreground: foreground,
            background: background,
            imageForeground: imageForeground,
            alignment: .top,
            duration: duration,
            transition: .move(edge: .top)
        )
    }
}

#Preview {
    
    @Previewable @State var manager = NoticeManager()
    
    VStack {
        Button("Toast") {
            manager.queueNotice(.toast(
                title: LocalizedStringResource(stringLiteral: "Hello, World"),
                message: LocalizedStringResource(stringLiteral: "How Are You?"),
                systemImage: "pencil.circle.fill",
                duration: .seconds(2)
            ))
        }
        
        Button("Message") {
            manager.queueNotice(.message(
                title: LocalizedStringResource(stringLiteral: "Hello, World"),
                message: LocalizedStringResource(stringLiteral: "How Are You?"),
                systemImage: "pencil.circle.fill",
                duration: .seconds(2)
            ))
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .handleNotices(from: manager)
}
