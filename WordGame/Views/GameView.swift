//
//  ContentView.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import SwiftUI

struct GameView: View {
    @State private var loading = true
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var themeManager = ThemeManager()
   
    var body: some View {
        ZStack{
            themeManager.accentColor.ignoresSafeArea()
            if(loading){
                loadingView
            }else{
                if(!viewModel.gameOver){
                    playView
                }else{
                    Spacer()
                    gameOverView
                    Spacer()
                }
            }
        }
        .modifier(MediumText())
        .animation(.easeInOut(duration: 1.25), value: loading)
        .animation(.linear(duration: 3.25), value: viewModel.gameOver)
        .animation(.easeInOut(duration: 1), value: viewModel.waitingForRequest)
        .animation(.linear(duration: 1.6), value: viewModel.newRecord)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                loading = false
                viewModel.startGame()
            }
        }
    }
    
    var loadingView: some View {
        VStack {
            if(viewModel.tutorialMode){
                Text("Welcome!")
                    .modifier(TitleText())
                    .padding()
                Text("Loading Tutorial Puzzle")
                    .padding()
                    .padding(.bottom, 100)
            }
            else if(viewModel.practiceMode){
                CountDownView()
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
            if(viewModel.tutorialMode){
                Text("Tutorial")
                    .modifier(NumberCounter())
            }else{
                Text("\(viewModel.secondsElapsed, specifier: "%.1f")")
                    .modifier(NumberCounter())
            }
            ProgressView(value: viewModel.gameProgress)
                .tint(themeManager.themeColor)
                .padding()
            Text(viewModel.currentWord.hint)
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
                    viewModel.hintIntent()
                }) {
                    HintTimer(progress: viewModel.hintProgress)
                }
                .disabled(!viewModel.hintButtonActive)
                .padding()
                Spacer()
                Button{
                    viewModel.submitWord()
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
            Text("\(viewModel.puzzleName) Puzzle")
            Text("Time: \(viewModel.secondsElapsed.formatted())s")
                .padding()
            
            if(viewModel.requestError && !viewModel.tutorialMode){
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
                if(viewModel.newRecord && !viewModel.tutorialMode){
                    Text("New Record!")
                        .modifier(TitleText())
                        .opacity(viewModel.waitingForRequest ? 0 : 1)
                        .frame(height: 50)
                        .padding(.bottom, 100)
                }
                if(viewModel.tutorialMode){
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
