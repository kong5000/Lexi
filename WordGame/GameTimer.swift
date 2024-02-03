/*
See LICENSE folder for this sample’s licensing information.
*/

import Foundation

final class GameTimer: ObservableObject {
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
        
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
        
        timer?.tolerance = 0.1
    }
    
    func stopTimer() {
        timer?.invalidate()
    }

    nonisolated private func update() {
            secondsElapsed += 0.1
    }
    
    func reset(lengthInMinutes: Int) {
        secondsElapsed = 0
    }
}
