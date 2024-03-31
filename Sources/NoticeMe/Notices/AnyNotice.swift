//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

/// A type-erased `Notice`
public struct AnyNotice {
    internal var notice: any Noticeable
    
    private init(_ notice: any Noticeable) {
        self.notice = notice
    }
}

// MARK: Duration
@available(iOS 16, *)
public extension AnyNotice {
    /// A `Notice` that displays a small bubble of information using text and an optional system image at the bottom of the screen.
    static func toast(
        _ title: String,
        message: String? = nil,
        duration: Duration = .seconds(2),
        systemIcon: String? = nil,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white
    ) -> AnyNotice {
        AnyNotice(Toast(title, message: message, systemIcon: systemIcon, duration: duration, textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .bottom))
    }
    
    /// A `Notice` that displays a bar of text at the bottom of the screen.
    static func snackbar(
        _ message: String,
        duration: Duration = .seconds(2),
        textColor: Color = .white,
        backgroundColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25)
    ) -> AnyNotice {
        AnyNotice(Snackbar(message, duration: duration, textColor: textColor, backgroundColor: backgroundColor))
    }
    
    /// A `Notice` that displays a small bubble of information using text and an optional system image at the top of the screen.
    static func message(
        _ title: String,
        message: String? = nil,
        duration: Duration = .seconds(2),
        systemIcon: String? = nil,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white
    ) -> AnyNotice {
        var notice = Toast(title, message: message, systemIcon: systemIcon, duration: duration, textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .top)
        
        notice.noticeInfo.transition = .move(edge: .top)
        
        return AnyNotice(notice)
    }
    
    /// A `Notice` that places a "Patch" at the center of the screen, displaying a System Image and a small amount of text.
    static func patch(
        _ title: String,
        duration: Duration = .seconds(2),
        systemIcon: String,
        iconColor: Color = .black
    ) -> AnyNotice {
        return AnyNotice(Patch(title, systemIcon: systemIcon, iconColor: iconColor, duration: duration))
    }
}

// MARK: Time
public extension AnyNotice {
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
        AnyNotice(Toast(title, message: message, systemIcon: systemIcon, lasting: time, textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .bottom))
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
        var notice = Toast(title, message: message, systemIcon: systemIcon, lasting: time, textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .top)
        
        notice.noticeInfo.transition =
        if #available(iOS 16.0, *) { .asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)) }
        else { .move(edge: .top) }
        
        return AnyNotice(notice)
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
}

// MARK: Old APIs
public extension AnyNotice {
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

        return AnyNotice(Toast(title, message: message, systemIcon: systemIcon, lasting: .milliseconds(Int(milliseconds)), textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .bottom))
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
        
        var notice = Toast(title, message: message, systemIcon: systemIcon, lasting: .milliseconds(Int(milliseconds)), textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .top)
        
        notice.noticeInfo.transition =
        if #available(iOS 16.0, *) { .asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)) }
        else { .move(edge: .top) }
        
        return AnyNotice(notice)
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
