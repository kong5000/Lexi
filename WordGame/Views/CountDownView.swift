//
//  TimerView.swift
//  WordGame
//
//  Created by k on 2024-02-13.
//

import SwiftUI

struct CountDownView: View {
    @State private var timeRemaining = ""
    
    func updateCountdown() {
        let currentDate = Date()
        let calendar = Calendar.current
        if let nextMidnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate.addingTimeInterval(24 * 60 * 60)) {
            let components = calendar.dateComponents([.hour, .minute, .second], from: currentDate, to: nextMidnight)
            if let hours = components.hour, let minutes = components.minute, let seconds = components.second {
                timeRemaining = String(format: "%02dh %02dm %02ds", hours, minutes, seconds)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("New daily puzzle in:")
            Text(timeRemaining)
                .modifier(NumberCounter())
            Text("Loading practice puzzle")
                .padding()
                .padding(.bottom, 100)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                updateCountdown()
            }
        }
    }
}

#Preview {
    CountDownView()
}
