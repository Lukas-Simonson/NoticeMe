//
//  SwiftUIView.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

internal struct Snackbar: Noticeable {

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
    internal init(
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
    internal init(
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

#Preview {
    ZStack {
        Snackbar("Hello, World", lasting: .seconds(2))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
