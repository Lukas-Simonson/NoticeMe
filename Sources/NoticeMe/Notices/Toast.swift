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
        alignment: Alignment = .bottom,
        transition: AnyTransition
    ) {
        self.title = title
        self.message = message
        self.systemIcon = systemIcon
        self.textColor = textColor
        self.systemIconColor = systemIconColor
        self.backgroundColor = backgroundColor
        
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
        alignment: Alignment = .bottom,
        transition: AnyTransition
    ) {
        self.title = title
        self.message = message
        self.systemIcon = systemIcon
        self.textColor = textColor
        self.systemIconColor = systemIconColor
        self.backgroundColor = backgroundColor
        
        self.noticeInfo = NoticeInfo(
            alignment: .bottom,
            duration: duration,
            transition: transition
        )
    }
}

// MARK: Toast AnyView
public extension AnyView {
    /// A `Notice` that displays a small bubble of information using text and an optional system image at the bottom of the screen.
    @available(iOS 16, *)
    static func toast(
        _ title: String,
        message: String? = nil,
        duration: Duration = .seconds(2),
        systemIcon: String? = nil,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white
    ) -> AnyNotice {
        AnyNotice(Toast(title, message: message, systemIcon: systemIcon, duration: duration, textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .bottom, transition: .move(edge: .bottom)))
    }
    
    /// A `Notice` that displays a small bubble of information using text and an optional system image at the bottom of the screen.
    @available(iOS, deprecated: 16, renamed: "toast(title:message:duration:systemIcon:textColor:systemIconColor:backgroundColor:)")
    static func toast(
        _ title: String,
        message: String? = nil,
        lasting time: NoticeInfo.Time = .seconds(2),
        systemIcon: String? = nil,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white
    ) -> AnyNotice {
        let transition : AnyTransition = if #available(iOS 16.0, *) { .asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)) }
        else { .move(edge: .bottom) }
        
        return AnyNotice(Toast(title, message: message, systemIcon: systemIcon, lasting: time, textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .bottom,  transition: transition))
    }
    
    /// A `Notice` that displays a small bubble of information using text and an optional system image at the bottom of the screen.
    @available(*, deprecated, renamed: "toast(title:message:time:systemIcon:textColor:systemIconColor:backgroundColor:)")
    static func toast(
        _ title: String,
        message: String? = nil,
        seconds: Double = 2.0,
        systemIcon: String? = nil,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white
    ) -> AnyNotice {
        let milliseconds = seconds * 1000
        let transition : AnyTransition = if #available(iOS 16.0, *) { .asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)) }
        else { .move(edge: .bottom) }

        return AnyNotice(Toast(title, message: message, systemIcon: systemIcon, lasting: .milliseconds(Int(milliseconds)), textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .bottom, transition: transition))
    }
}

// MARK: Message AnyView
public extension AnyView {
    /// A `Notice` that displays a small bubble of information using text and an optional system image at the top of the screen.
    @available(iOS 16, *)
    static func message(
        _ title: String,
        message: String? = nil,
        duration: Duration = .seconds(2),
        systemIcon: String? = nil,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white
    ) -> AnyNotice {
        AnyNotice(Toast(title, message: message, systemIcon: systemIcon, duration: duration, textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .top, transition: .move(edge: .top)))
    }
    
    /// A `Notice` that displays a small bubble of information using text and an optional system image at the top of the screen.
    @available(iOS, deprecated: 16, renamed: "message(title:message:duration:systemIcon:textColor:systemIconColor:backgroundColor:)")
    static func message(
        _ title: String,
        message: String? = nil,
        lasting time: NoticeInfo.Time = .seconds(2),
        systemIcon: String? = nil,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white
    ) -> AnyNotice {
        let transition: AnyTransition =
        if #available(iOS 16.0, *) { .asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)) }
        else { .move(edge: .top) }
        
        return AnyNotice(Toast(title, message: message, systemIcon: systemIcon, lasting: time, textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .top, transition: transition))
    }
    
    /// A `Notice` that displays a small bubble of information using text and an optional system image at the top of the screen.
    @available(*, deprecated, renamed: "message(title:message:time:systemIcon:textColor:systemIconColor:backgroundColor:)")
    static func message(
        _ title: String,
        message: String? = nil,
        seconds: Double = 2.0,
        systemIcon: String? = nil,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white
    ) -> AnyNotice {
        let milliseconds = seconds * 1000
        let transition: AnyTransition =
        if #available(iOS 16.0, *) { .asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)) }
        else { .move(edge: .top) }
        
        return AnyNotice(Toast(title, message: message, systemIcon: systemIcon, lasting: .milliseconds(Int(milliseconds)), textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .top, transition: transition))
    }
}

#Preview {
    ZStack {
        Toast("Hello, World", message: "How Are You?", systemIcon: "pencil.circle.fill", lasting: .seconds(2), transition: .move(edge: .bottom))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
