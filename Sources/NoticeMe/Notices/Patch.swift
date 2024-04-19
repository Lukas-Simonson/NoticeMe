//
//  SwiftUIView.swift
//
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

public struct Patch: Noticeable {
    
    public let noticeInfo: NoticeInfo
    
    private var title: String
    private var systemIcon: String
    private var iconColor: Color
    
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

extension Patch {
    public init(
        _ title: String,
        systemIcon: String,
        iconColor: Color = .black,
        lasting time: NoticeInfo.Time
    ) {
        self.title = title
        self.systemIcon = systemIcon
        self.iconColor = iconColor
        self.noticeInfo = NoticeInfo(
            alignment: .center,
            lasting: time,
            transition: .scale
        )
    }
    
    @available(iOS 16, *)
    public init(
        _ title: String,
        systemIcon: String,
        iconColor: Color = .black,
        duration: Duration
    ) {
        self.title = title
        self.systemIcon = systemIcon
        self.iconColor = iconColor
        self.noticeInfo = NoticeInfo(
            alignment: .center,
            duration: duration,
            transition: .scale
        )
    }
}

public extension AnyNotice {
    
    /// A `Notice` that places a "Patch" at the center of the screen, displaying a System Image and a small amount of text.
    @available(iOS 16, *)
    static func patch(
        _ title: String,
        duration: Duration = .seconds(2),
        systemIcon: String,
        iconColor: Color = .black
    ) -> AnyNotice {
        return AnyNotice(Patch(title, systemIcon: systemIcon, iconColor: iconColor, duration: duration))
    }
    
    /// A `Notice` that places a "Patch" at the center of the screen, displaying a System Image and a small amount of text.
    @available(iOS, deprecated: 16, renamed: "patch(title:duration:systemIcon:iconColor:)")
    static func patch(
        _ title: String,
        lasting time: NoticeInfo.Time,
        systemIcon: String,
        iconColor: Color = .black
    ) -> AnyNotice {
        return AnyNotice(Patch(title, systemIcon: systemIcon, iconColor: iconColor, lasting: time))
    }
    
    /// A `Notice` that places a "Patch" at the center of the screen, displaying a System Image and a small amount of text.
    @available(*, deprecated, renamed: "patch(title:time:systemIcon:iconColor:)")
    static func patch(
        _ title: String,
        seconds: Double = 2.0,
        systemIcon: String,
        iconColor: Color = .black
    ) -> AnyNotice {
        let milliseconds = seconds * 1000
        
        return AnyNotice(Patch(title, systemIcon: systemIcon, iconColor: iconColor, lasting: .milliseconds(Int(milliseconds))))
    }
}

#Preview {
    Patch("Error", systemIcon: "xmark", iconColor: .pink, lasting: .seconds(2))
}
