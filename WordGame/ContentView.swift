//
//  ContentView.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var gameTime = 0.0
    
    @State var ending = false
    @State private var keyWords = [String]()
    @State private var solvedWords = [String]()
    @State private var showingAlert = false
    
    @State private var viewModel = LocalDictionary()
    
    @State private var gameTimer:Timer?
    
    @State private var showGame = true
    

    
    private func startGameTimer() {
        gameTimer?.invalidate()
        gameTime = 0.0
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            gameTime += 0.1
        }
        
        if let timer = gameTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    private func resetGame() {
//        viewModel = LocalDictionary()
//
//        viewModel.reset()
            
        startGameTimer()
    }
    
    var body: some View {
        ZStack{
            if(showGame){
                VStack {
                    SegmentedProgress(progress: Double(solvedWords.count) / Double(viewModel.gameWords.count))
                        .padding()
                    HStack{
                        Text("\(gameTime, specifier: "%.1f")")
                            .font(.system(size: 20).monospacedDigit())
                    }
                    
                    Text(viewModel.gameWords[viewModel.questionIndex].hint)
                        .font(.system(size: 25))
                        .frame(height: 120)
                        .padding()
                    
                    HStack(alignment: .top){
                        VStack{
                            Wheel(selectedLetter: $viewModel.letter1, letters: viewModel.wheelLetters[0], hint: $viewModel.hint1                                      )
                                .padding()
                            Spacer()
                        }
                        VStack{
                            Wheel(selectedLetter: $viewModel.letter2, letters: viewModel.wheelLetters[1], hint: $viewModel.hint2)
                                .padding()
                            Spacer()
                        }
                        VStack{
                            Wheel(selectedLetter: $viewModel.letter3, letters: viewModel.wheelLetters[2], hint: $viewModel.hint3)
                                .padding()
                            Spacer()
                        }
                        VStack{
                            Wheel(selectedLetter: $viewModel.letter4, letters: viewModel.wheelLetters[3], hint: $viewModel.hint4)
                                .padding()
                            Spacer()
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.top,50)
                    
                    HStack{
                        Button(action: {
                            if viewModel.hintButtonActive {
                                viewModel.generateHint()
                            }
                        }) {
                            HintTimer(progress: viewModel.hintProgress)
                        }
                        .disabled(!viewModel.hintButtonActive)
                        .padding()
                        Button{
                            if(viewModel.submitWord()){
                                AudioServicesPlaySystemSound(1305)
                                viewModel.startHintCount()
                            }else{
                                
                            }
                        }label:{
                            Text("SUBMIT")
                                .padding()
                                .foregroundColor(.white)
                                .background(.black)
                                .font(.title)
                                .clipShape(Capsule())
                        }.padding()
                    }
                }.onAppear(){
                    resetGame()
                }
                .alert("WIN", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {
                        resetGame()
                    }
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
