//
//  HintTimer.swift
//  WordGame
//
//  Created by k on 2024-02-02.
//

import SwiftUI

struct CircleButton: View {
    @StateObject private var themeManager = ThemeManager()

    var text: String
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    themeManager.themeColor,
                    lineWidth: 10
                )
                .frame(width: 100)

            Circle()
                .fill( themeManager.themeColor)
                .frame(width: 70)
                .rotationEffect(.degrees(-90))
            
            Text(text)
                .font(.system(size: 18))
                .frame(width: 50, height: 50)
                .foregroundColor(themeManager.accentColor)
        }.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CircleButton(text: "text")
}
