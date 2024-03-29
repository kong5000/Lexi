//
//  TextStyling.swift
//  WordGame
//
//  Created by k on 2024-02-11.
//

import Foundation
import SwiftUI

struct TitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 35))
    }
}

struct NumberCounter: ViewModifier {
    private var themeManager = ThemeManager()

    func body(content: Content) -> some View {
        content
            .font(.system(size: 25).monospacedDigit())
            .foregroundColor(themeManager.themeColor)
    }
}

struct MediumText: ViewModifier {
    private var themeManager = ThemeManager()

    func body(content: Content) -> some View {
        content
            .font(.system(size: 25))
            .foregroundColor(themeManager.themeColor)
    }
}

    
