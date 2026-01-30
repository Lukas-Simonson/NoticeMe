//
//  Snackbar.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

public struct Snackbar: Noticeable {

    public let noticeInfo: NoticeInfo
    
    private let message: LocalizedStringResource
    private let foreground: AnyShapeStyle
    private let background: AnyShapeStyle
    
    public var body: some View {
        Text(message)
            .font(.headline)
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity)
            .padding()
            .background(background)
    }
}

extension Snackbar {
    public init(
        _ message: LocalizedStringResource,
        duration: Duration = .seconds(2),
        foreground: some ShapeStyle = Color.white,
        background: some ShapeStyle = Color(red: 0.25, green: 0.25, blue: 0.25)
    ) {
        self.message = message
        self.foreground = AnyShapeStyle(foreground)
        self.background = AnyShapeStyle(background)
        self.noticeInfo = NoticeInfo(
            alignment: .bottom,
            duration: duration,
            transition: .move(edge: .bottom)
        )
    }
}

public extension Noticeable where Self == Snackbar {
    static func snackbar(
        _ message: LocalizedStringResource,
        duration: Duration = .seconds(2),
        foreground: some ShapeStyle = Color.white,
        background: some ShapeStyle = Color(red: 0.25, green: 0.25, blue: 0.25)
    ) -> Snackbar {
        Snackbar(message, duration: duration, foreground: foreground, background: background)
    }
}

#Preview {
    
    @Previewable @State var manager = NoticeManager()
    
    ZStack {
        Button("Snackbar") {
            manager.queueNotice(.snackbar(LocalizedStringResource(stringLiteral: "Hello, World")))
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .handleNotices(from: manager)
}
