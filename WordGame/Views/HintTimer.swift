//
//  HintTimer.swift
//  WordGame
//
//  Created by k on 2024-02-02.
//

import SwiftUI

struct HintTimer: View {
    var progress: Double
    @StateObject private var themeManager = ThemeManager()

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    themeManager.themeColor.opacity(0.33),
                    lineWidth: 10
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    themeManager.themeColor,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .animation(.easeOut, value: progress)

            Circle()
                .fill( progress < 1.0 ?  themeManager.themeColor.opacity(0.33) : themeManager.themeColor)
                .frame(width: 70)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            Text("HINT")
                .font(.system(size: 22))
                .frame(width: 50, height: 50)
                .foregroundColor(themeManager.accentColor)
        }.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HintTimer(progress: 0.9)
}
