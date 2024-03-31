//
//  SwiftUIView.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

internal struct Patch: Noticeable {
    
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
    internal init(
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
    internal init(
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

#Preview {
    Patch("Error", systemIcon: "xmark", iconColor: .pink, lasting: .seconds(2))
}
