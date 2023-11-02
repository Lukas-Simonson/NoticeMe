//
//  File.swift
//  
//
//  Created by Lukas Simonson on 11/1/23.
//

import SwiftUI

public struct AnyNotice {
    internal var notice: any Notice
    
    private init(_ notice: any Notice) {
        self.notice = notice
    }
    
    public static func toast(
        _ title: String,
        message: String? = nil,
        seconds: Double = 2.0,
        systemIcon: String? = nil,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white
    ) -> AnyNotice {
        AnyNotice(Toast(title, message: message, systemIcon: systemIcon, durationSeconds: seconds, textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .bottom))
    }
    
    public static func snackbar(
        _ message: String,
        seconds: Double = 2.0,
        textColor: Color = .white,
        backgroundColor: Color = Color(red: 0.25, green: 0.25, blue: 0.25)
    ) -> AnyNotice {
        AnyNotice(Snackbar(message, durationSeconds: seconds, textColor: textColor, backgroundColor: backgroundColor))
    }
    
    public static func message(
        _ title: String,
        message: String? = nil,
        seconds: Double = 2.0,
        systemIcon: String? = nil,
        textColor: Color = .black,
        systemIconColor: Color = .black,
        backgroundColor: Color = .white
    ) -> AnyNotice {
        AnyNotice(Toast(title, message: message, systemIcon: systemIcon, durationSeconds: seconds, textColor: textColor, systemIconColor: systemIconColor, backgroundColor: backgroundColor, alignment: .top))
    }
    
    public static func patch(
        _ title: String,
        seconds: Double = 2.0,
        systemIcon: String,
        iconColor: Color = .black
    ) -> AnyNotice {
        AnyNotice(Patch(title, systemIcon: systemIcon, iconColor: iconColor, durationSeconds: seconds))
    }
}
