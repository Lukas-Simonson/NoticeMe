//
//  SwiftUIView.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

public struct Snackbar: Noticeable {

    public let noticeInfo: NoticeInfo
    
    private var message: String
    private var textColor: Color
    private var backgroundColor: Color
    
    public var body: some View {
        Text(message)
            .font(.headline)
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
    }
}

extension Snackbar {
    public init(
        _ message: String,
        lasting time: NoticeInfo.Time,
        textColor: Color = .white,
        backgroundColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25)
    ) {
        self.message = message
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.noticeInfo = NoticeInfo(
            alignment: .bottom,
            lasting: time,
            transition: .move(edge: .bottom)
        )
    }
    
    @available(iOS 16, *)
    public init(
        _ message: String,
        duration: Duration,
        textColor: Color = .white,
        backgroundColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25)
    ) {
        self.message = message
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.noticeInfo = NoticeInfo(
            alignment: .bottom,
            duration: duration,
            transition: .move(edge: .bottom)
        )
    }
}

public extension AnyNotice {
    /// A `Notice` that displays a bar of text at the bottom of the screen.
    @available(iOS 16, *)
    static func snackbar(
        _ message: String,
        duration: Duration = .seconds(2),
        textColor: Color = .white,
        backgroundColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25)
    ) -> AnyNotice {
        AnyNotice(Snackbar(message, duration: duration, textColor: textColor, backgroundColor: backgroundColor))
    }
    
    /// A `Notice` that displays a bar of text at the bottom of the screen.
    @available(iOS, deprecated: 16, renamed: "snackbar(messag:time:textColor:backgroundColor:)")
    static func snackbar(
        _ message: String,
        lasting time: NoticeInfo.Time = .seconds(2),
        textColor: Color = .white,
        backgroundColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25)
    ) -> AnyNotice {
        AnyNotice(Snackbar(message, lasting: time, textColor: textColor, backgroundColor: backgroundColor))
    }
    
    /// A `Notice` that displays a bar of text at the bottom of the screen.
    @available(*, deprecated, renamed: "snackbar(messag:time:textColor:backgroundColor:)")
    static func snackbar(
        _ message: String,
        seconds: Double = 2.0,
        textColor: Color = .white,
        backgroundColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25)
    ) -> AnyNotice {
        let milliseconds = seconds * 1000
        
        return AnyNotice(Snackbar(message, lasting: .milliseconds(Int(milliseconds)), textColor: textColor, backgroundColor: backgroundColor))
    }
}

#Preview {
    ZStack {
        Snackbar("Hello, World", lasting: .seconds(2))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
