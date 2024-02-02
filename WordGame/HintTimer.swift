//
//  HintTimer.swift
//  WordGame
//
//  Created by k on 2024-02-02.
//

import SwiftUI

struct HintTimer: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.black.opacity(0.33),
                    lineWidth: 10
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.black,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
            Circle()
                .fill( progress < 1.0 ?  Color.black.opacity(0.33) : Color.black)
                .frame(width: 70)
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
            Text("HINT")
                .font(.headline)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .animation(.easeOut, value: progress)
        }.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            .animation(.easeOut, value: progress)
    }
}

#Preview {
    HintTimer(progress: 0.9)
}
