//
//  ContentView.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import SwiftUI
import AVFoundation

struct GameView: View {
    @State private var showingAlert = false
    @State private var loading = true
    @State private var message = "Loading Todays Puzzle"
    @State private var viewModel = GameViewModel()
    @StateObject private var gameTimer = GameTimer()
    @StateObject private var themeManager = ThemeManager()
    @AppStorage("lastGameDate") private var lastGameDate = "Jan 01"
    @State private var timeRemaining = ""
    @State private var practiceMode = false

    private func resetGame() {
        viewModel.reset()
        gameTimer.startTimer()
    }
    
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
        ZStack{
            themeManager.accentColor.ignoresSafeArea()
            if(loading){
                VStack {
                    if(practiceMode){
                        VStack {
                            Text("New daily puzzle in \(timeRemaining)")
                                .font(.system(size: 25))
                                 .foregroundColor(themeManager.themeColor)
                                 .padding()
                            Text("Loading practice mode")
                                .font(.system(size: 25))
                                 .foregroundColor(themeManager.themeColor)
                        }       .onAppear {
                            updateCountdown()
                                // Update the countdown every second
                                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                    updateCountdown()
                                }
                        }
                    }else{
                        Text("Loading the daily puzzle")
                            .font(.system(size: 25))
                            .foregroundColor(themeManager.themeColor)
                            .frame(height: 120)
                            .padding()
                    }
                }
            }else{
                VStack {
                    Text("\(gameTimer.secondsElapsed, specifier: "%.1f")")
                        .font(.system(size: 25).monospacedDigit())
                        .foregroundColor(themeManager.themeColor)
                    SegmentedProgress(progress: viewModel.gameProgress)
                        .padding()
                    Text(viewModel.gameWords[viewModel.questionIndex].hint)
                        .font(.system(size: 25))
                        .foregroundColor(themeManager.themeColor)
                        .frame(height: 120)
                        .padding()
                    
                    HStack(alignment: .top){
                        VStack{
                            Wheel(selectedLetter: $viewModel.letter1, letters: viewModel.wheelLetters[0], hint: $viewModel.hint1                                      )
                            Spacer()
                        }
                        VStack{
                            Wheel(selectedLetter: $viewModel.letter2, letters: viewModel.wheelLetters[1], hint: $viewModel.hint2)
                            Spacer()
                        }
                        VStack{
                            Wheel(selectedLetter: $viewModel.letter3, letters: viewModel.wheelLetters[2], hint: $viewModel.hint3)
                            Spacer()
                        }
                        VStack{
                            Wheel(selectedLetter: $viewModel.letter4, letters: viewModel.wheelLetters[3], hint: $viewModel.hint4)
                            Spacer()
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.top,50)
                    .padding(.bottom, 50)
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            if viewModel.hintButtonActive {
                                viewModel.generateHint()
                                AudioServicesPlaySystemSound(1114    )
                                
                            }
                        }) {
                            HintTimer(progress: viewModel.hintProgress)
                        }
                        .disabled(!viewModel.hintButtonActive)
                        .padding()
                        Spacer()
                        Button{
                            if(viewModel.submitWord()){
                                AudioServicesPlaySystemSound(1305)
                                viewModel.startHintCount()
                                if(viewModel.gameProgress >= 1.0){
                                    showingAlert = true
                                    gameTimer.stopTimer()
                                }
                            }else{
                                AudioServicesPlaySystemSound(1306)
                            }
                        }label:{
                            Text("SUBMIT")
                                .padding()
                                .foregroundColor(themeManager.accentColor)
                                .background(themeManager.themeColor)
                                .font(.system(size: 22))
                                .clipShape(Capsule())
                        }.padding()
                        Spacer()
                    }
                    .additionalPaddingForiPad()
                    
                }
                .onAppear(){
                    resetGame()
                    gameTimer.startTimer()
                }

                .alert("WIN", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {
                        resetGame()
                    }
                }
            }
        }.animation(.easeInOut(duration: 1.25), value: loading)

        .onAppear {
            // Simulate loading state for 3 seconds
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            let today = dateFormatter.string(from: Date())
            if(lastGameDate != today){
                lastGameDate = today
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    loading = false
                }
            }else{
                practiceMode = true
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                    loading = false
                }
            }
          
     }
    }
}

extension View {
    func additionalPaddingForiPad() -> some View {
#if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return AnyView(self.padding(.bottom, 50))
        } else {
            return AnyView(self)
        }
#else
        return AnyView(self)
#endif
    }
}



#Preview {
    GameView()
}
