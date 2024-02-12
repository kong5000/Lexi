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
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var gameTimer = GameTimer()
    @StateObject private var themeManager = ThemeManager()
    @AppStorage("lastGameDate") private var lastGameDate = "Jan 01"
    @State private var timeRemaining = ""
    @State private var practiceMode = false
    @State private var gameOver = false
    @State private var puzzleName = ""
    
    @AppStorage("top10") private var top10Finishes = 0
    @AppStorage("top100") private var top100Finishes = 0
    @AppStorage("dailyFinishes") private var dailyFinishes = 0
    @AppStorage("topFinish") private var topFinish = 999999
    @AppStorage("tutorial") private var tutorial = true
    
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
                loadingView
            }else{
                if(!gameOver){
                    playView
                }else{
                    Spacer()
                    gameOverView
                    Spacer()
                }
            }
        }
        .modifier(MediumText())
        .foregroundColor(themeManager.themeColor)
        .animation(.easeInOut(duration: 1.25), value: loading)
        .animation(.linear(duration: 3.25), value: gameOver)
        .animation(.easeInOut(duration: 1), value: viewModel.waitingForRequest)
        .animation(.linear(duration: 1.6), value: viewModel.newRecord)
        .onAppear {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            let today = dateFormatter.string(from: Date())
            
            if(tutorial){
                puzzleName = "Tutorial"
                viewModel.startTutorialMode()
            }else if(lastGameDate != today){
                lastGameDate = today
                puzzleName = today
                viewModel.startDailyMode()
            }else{
                puzzleName = "Practice"
                practiceMode = true
                viewModel.startPracticeMode()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                loading = false
                gameTimer.startTimer()
                viewModel.startHintCount()
            }
        }
    }
    
    var loadingView: some View {
        VStack {
            if(tutorial){
                Text("Welcome!")
                    .modifier(TitleText())
                    .padding()
                Text("Loading Tutorial Puzzle")
                    .padding()
                    .padding(.bottom, 100)
            }
            else if(practiceMode){
                VStack {
                    Text("New daily puzzle in:")
                    Text(timeRemaining)
                        .modifier(NumberCounter())
                    Text("Loading practice puzzle")
                        .padding()
                        .padding(.bottom, 100)
                }
                .onAppear {
                    updateCountdown()
                    // Update the countdown every second
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        updateCountdown()
                    }
                }
            }else{
                Text("Loading the daily puzzle")
                    .frame(height: 120)
                    .padding()
                    .padding(.bottom, 100)
            }
        }
    }
    
    var playView: some View {
        VStack {
            if(tutorial){
                Text("Tutorial")
                    .modifier(NumberCounter())
            }else{
                Text("\(gameTimer.secondsElapsed, specifier: "%.1f")")
                    .modifier(NumberCounter())
            }
            ProgressView(value: viewModel.gameProgress)
                .tint(themeManager.themeColor)
                .padding()
            Text(viewModel.gameWords[viewModel.questionIndex].hint)
                .frame(height: 120)
                .padding()
            
            HStack(alignment: .top){
                VStack{
                    Wheel(selectedLetter: $viewModel.letter1, letters: viewModel.wheelLetters[0], hint: viewModel.hints[0])
                    Spacer()
                }
                VStack{
                    Wheel(selectedLetter: $viewModel.letter2, letters: viewModel.wheelLetters[1], hint: viewModel.hints[1])
                    Spacer()
                }
                VStack{
                    Wheel(selectedLetter: $viewModel.letter3, letters: viewModel.wheelLetters[2], hint: viewModel.hints[2])
                    Spacer()
                }
                VStack{
                    Wheel(selectedLetter: $viewModel.letter4, letters: viewModel.wheelLetters[3], hint: viewModel.hints[3])
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
                        AudioServicesPlaySystemSound(1114)
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
                            gameTimer.stopTimer()
                            if(tutorial){
                                tutorial = false
                            }
                            if(!practiceMode){
                                let payload: [String: Any] = [
                                    "puzzleId": puzzleName,
                                    "score": gameTimer.secondsElapsed,
                                ]
                                viewModel.sendScore(payload:payload)
                            }
                            withAnimation{
                                gameOver = true
                            }
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
    }
    
    var gameOverView: some View {
        VStack{
            Text("\(puzzleName) Puzzle")
            Text("Time: \(gameTimer.secondsElapsed.formatted())s")
                .padding()
            
            if(viewModel.requestError && !tutorial){
                Text("Sorry, could not connect to our server for your daily ranking")
                    .opacity(viewModel.waitingForRequest ? 0 : 1)
                    .padding()
            }else{
                Text("Loading Results...")
                    .opacity(viewModel.waitingForRequest ? 1 : 0)
                    .frame(height: 50)
                Text(viewModel.resultText)
                    .opacity(viewModel.waitingForRequest ? 0 : 1)
                    .frame(height: 50)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 100)
                if(viewModel.newRecord && !tutorial){
                    Text("New Record!")
                        .modifier(TitleText())
                        .opacity(viewModel.waitingForRequest ? 0 : 1)
                        .frame(height: 50)
                        .padding(.bottom, 100)
                }
                if(tutorial){
                    Text("Daily puzzle now available!")
                        .font(.system(size: 30))
                        .opacity(viewModel.waitingForRequest ? 0 : 1)
                        .padding()
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
