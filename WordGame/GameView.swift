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
    @State private var viewModel = GameViewModel()
    @StateObject private var gameTimer = GameTimer()
    @StateObject private var themeManager = ThemeManager()
    @AppStorage("lastGameDate") private var lastGameDate = "Jan 01"
    @State private var timeRemaining = ""
    @State private var practiceMode = false
    @State private var resultText = ""
    @State private var place = 0
    @State private var players = 0
    @State private var newRecord = false
    @State private var waitingForRequest = false
    @State private var gameOver = false
    @State private var requestError = false
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
    
    func ordinalNumber(_ number: Int) -> String {
        var numberSuffix = ""
        
        switch number % 10 {
        case 1:
            numberSuffix = "st"
        case 2:
            numberSuffix = "nd"
        case 3:
            numberSuffix = "rd"
        default:
            numberSuffix = "th"
        }
        
        // Special case for numbers ending in 11, 12, and 13
        if (number % 100) / 10 == 1 {
            numberSuffix = "th"
        }
        
        return "\(number)\(numberSuffix)"
    }
    
    func sendPostRequest() {
        guard let url = URL(string: "https://us-central1-lexi-word-game.cloudfunctions.net/updatePuzzleScore") else {
            requestError = true
            waitingForRequest = false
            return
        }
        
        let payload: [String: Any] = [
            "puzzleId": puzzleName,
            "score": gameTimer.secondsElapsed,
            "userId": "userid123abc"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: payload)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                requestError = true
                waitingForRequest = false
            }
            
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    place = jsonResponse?["place"] as! Int
                    players = jsonResponse?["totalPlayers"] as! Int
                    waitingForRequest = false
                    resultText = "\(ordinalNumber(place)) out of \(players) players"
                    
                    if(place <= 10){
                        top10Finishes += 1
                    }else if(place <= 100){
                        top100Finishes += 1
                    }
                    dailyFinishes += 1
                    if(place < topFinish){
                        topFinish = place
                        newRecord = true
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    requestError = true
                    waitingForRequest = false
                }
            }
        }.resume()
    }
    
    var body: some View {
        ZStack{
            themeManager.accentColor.ignoresSafeArea()
            if(loading){
                VStack {
                    if(tutorial){
                        Text("Welcome!")
                            .font(.system(size: 35))
                            .foregroundColor(themeManager.themeColor)
                            .padding()
                        Text("Loading Tutorial Puzzle")
                            .font(.system(size: 25))
                            .foregroundColor(themeManager.themeColor)
                            .padding()
                            .padding(.bottom, 100)
                    }
                    else if(practiceMode){
                        VStack {
                            Text("New daily puzzle in:")
                                .font(.system(size: 25))
                                .foregroundColor(themeManager.themeColor)
                            Text(timeRemaining)
                                .font(.system(size: 25).monospacedDigit())
                                .foregroundColor(themeManager.themeColor)
                                .font(.system(size: 25))
                                .foregroundColor(themeManager.themeColor)
                            Text("Loading practice puzzle")
                                .font(.system(size: 25))
                                .foregroundColor(themeManager.themeColor)
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
                            .font(.system(size: 25))
                            .foregroundColor(themeManager.themeColor)
                            .frame(height: 120)
                            .padding()
                            .padding(.bottom, 100)
                    }
                }
            }else{
                if(!gameOver){
                    VStack {
                        if(tutorial){
                            Text("Tutorial")
                                .font(.system(size: 25).monospacedDigit())
                                .foregroundColor(themeManager.themeColor)
                        }else{
                            Text("\(gameTimer.secondsElapsed, specifier: "%.1f")")
                                .font(.system(size: 25).monospacedDigit())
                                .foregroundColor(themeManager.themeColor)
                        }
                        ProgressView(value: viewModel.gameProgress)
                            .tint(themeManager.themeColor)
                            .padding()
                        Text(viewModel.gameWords[viewModel.questionIndex].hint)
                            .font(.system(size: 25))
                            .foregroundColor(themeManager.themeColor)
                            .frame(height: 120)
                            .padding()
                        
                        HStack(alignment: .top){
                            VStack{
                                Wheel(selectedLetter: $viewModel.letter1, letters: viewModel.wheelLetters[0], hint: $viewModel.hint1)
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
                                            sendPostRequest()
                                            waitingForRequest = true
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
                }else{
                    Spacer()
                    VStack{
                        Text("\(puzzleName) Puzzle")
                            .font(.system(size: 25))
                            .foregroundColor(themeManager.themeColor)
                        
                        Text("Time: \(gameTimer.secondsElapsed.formatted())s")
                            .font(.system(size: 25))
                            .foregroundColor(themeManager.themeColor)
                            .padding()
                        if(waitingForRequest){ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: themeManager.themeColor))
                                .scaleEffect(2)
                                .padding()
                                .opacity(waitingForRequest ? 1 : 0)
                        }
                        if(requestError && !tutorial){
                            Text("Sorry, could not connect to our server for your daily ranking").font(.system(size: 25))
                                .opacity(waitingForRequest ? 0 : 1)
                                .foregroundColor(themeManager.themeColor)
                                .padding()
                        }else{
                            Text(resultText)
                                .font(.system(size: 25))
                                .opacity(waitingForRequest ? 0 : 1)
                                .foregroundColor(themeManager.themeColor)
                                .frame(height: 50)
                                .padding(.bottom, 100)
                            
                            if(newRecord && !tutorial){
                                Text("New Record!")
                                    .font(.system(size: 35))
                                    .opacity(waitingForRequest ? 0 : 1)
                                    .foregroundColor(themeManager.themeColor)
                                    .frame(height: 50)
                                    .padding(.bottom, 100)
                            }
                            if(tutorial){
                                Text("Daily puzzle now available!")
                                    .font(.system(size: 30))
                                    .opacity(waitingForRequest ? 0 : 1)
                                    .foregroundColor(themeManager.themeColor)
                                    .padding()
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .animation(.easeInOut(duration: 1.25), value: loading)
        .animation(.linear(duration: 3.25), value: gameOver)
        .animation(.linear(duration: 1), value: waitingForRequest)
        .animation(.linear(duration: 1.6), value: newRecord)
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
