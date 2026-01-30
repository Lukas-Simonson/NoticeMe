//
//  Patch.swift
//
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

public struct Patch: Noticeable {
    
    public let noticeInfo: NoticeInfo
    
    private var title: LocalizedStringResource
    private var systemImage: String
    private var imageColor: Color
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 200)
            .overlay(alignment: .center) {
                VStack {
                    Image(systemName: systemImage)
                        .resizable()
                        .padding()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 100)
                        .foregroundStyle(imageColor)
                    
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
    public init(_ title: LocalizedStringResource, duration: Duration = .seconds(2), systemImage: String, imageColor: Color = .primary) {
        self.title = title
        self.systemImage = systemImage
        self.imageColor = imageColor
        self.noticeInfo = NoticeInfo(
            alignment: .center,
            duration: duration,
            transition: .scale
        )
    }
}

public extension Noticeable where Self == Patch {
    
    static func patch(_ title: LocalizedStringResource, duration: Duration = .seconds(2), systemImage: String, imageColor: Color = .primary) -> Patch {
        Patch(title, duration: duration, systemImage: systemImage, imageColor: imageColor)
    }
}

#Preview {
    
    @Previewable @State var manager = NoticeManager()
    
    ZStack {
        Button("Patch") {
            manager.queueNotice(.patch(LocalizedStringResource(stringLiteral: "Hello, World"), systemImage: "exclamationmark.triangle.fill"))
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .handleNotices(from: manager)
}
