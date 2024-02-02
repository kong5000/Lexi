/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation

/// Keeps time for a daily scrum meeting. Keep track of the total meeting time, the time for each speaker, and the name of the current speaker.

@MainActor
final class GameTimer: ObservableObject {
    /// The number of seconds since the beginning of the meeting.
    @Published var secondsElapsed = 0.0

    private weak var timer: Timer?
    private var frequency = 0.1
   

    init() {
        secondsElapsed = 0.0
    }
    
    func startTimer() {
        stopTimer()
        secondsElapsed = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            self?.update()
        }
        timer?.tolerance = 0.1
    }
    
    func stopTimer() {
        timer?.invalidate()
    }

    nonisolated private func update() {
        Task { @MainActor in
            secondsElapsed += 0.1
        }
    }
    
    func reset(lengthInMinutes: Int) {
        secondsElapsed = 0
    }
}
