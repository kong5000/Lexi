//
//  HintTimer.swift
//  WordGame
//
//  Created by k on 2024-02-02.
//

import SwiftUI

struct SettingButton: View {
    @StateObject private var themeManager = ThemeManager()

    var body: some View {
        ZStack {
            Circle()
                .frame(width: 80)
                .foregroundColor(themeManager.themeColor)
            Image(systemName: "gearshape")
                .font(.system(size: 60))
                .foregroundColor(themeManager.accentColor)
        }.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SettingButton()
}
