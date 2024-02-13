import Foundation

final class GameTimer: ObservableObject {
    @Published var secondsElapsed = 0.0

    private weak var timer: Timer?
    private var frequency = 0.1
    
    init() {
        secondsElapsed = 0.0
    }
    
    func startTimer(callback: @escaping()->Void) {
        stopTimer()
        secondsElapsed = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { [weak self] timer in
            callback()
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
        DispatchQueue.main.async { [weak self] in
            self?.secondsElapsed += 0.1
            
        }
    }
    
    func reset(lengthInMinutes: Int) {
        secondsElapsed = 0
    }
}
