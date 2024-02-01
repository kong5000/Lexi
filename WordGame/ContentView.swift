//
//  ContentView.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var keyWords = [String]()
    @State private var solvedWords = [String]()
    @State private var showingAlert = false
    @State private var freeLetter = "O"
    @State private var wheelLetters = [[String](),[String](),[String](),[String]()]
    
    
    @State private var letter1: String = ""
    @State private var letter2: String = ""
    @State private var letter3: String = ""
    @State private var letter4: String = ""
    
    
    @State private var hint1: String? = nil
    @State private var hint2: String? = nil
    @State private var hint3: String? = nil
    @State private var hint4: String? = nil
    
    @State private var hintState = 0
    
    @State private var state: Int = 0
    
    @State private var viewModel = LocalDictionary()
    
    @State private var countdown = 10
    @State private var isButtonActive = false
    private let initialCountdown = 10
    @State private var countdownTimer: Timer?

    private func startCountdown() {
        // Invalidate the previous timer if it exists
        countdownTimer?.invalidate()

        isButtonActive = false
        countdown = initialCountdown

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                isButtonActive = true
                timer.invalidate()
            }
        }
    }
    
    
    
    var body: some View {
        VStack {
            Text(hint1 ?? "NONE")
            Text("Score \(solvedWords.count)")
                .font(.system(size: 30)) // You can adjust the size (e.g., 20) as per your requirement
                .padding()
            
        
            Text(viewModel.gameWords[state].hint)
                .font(.system(size: 30))
                .padding(.bottom, 80)
                .padding(.top, 20)
            
                        
            HStack(alignment: .top){
                VStack{
                    Wheel(selectedLetter: $letter1, freeLetter: freeLetter, letters: wheelLetters[0], hint: $hint1)
                        .padding()
                    Spacer()
                }
                VStack{
                    Wheel(selectedLetter: $letter2, freeLetter: freeLetter, letters: wheelLetters[1], hint: $hint2)
                        .padding()
                    Spacer()
                }
                VStack{
                    Wheel(selectedLetter: $letter3, freeLetter: freeLetter, letters: wheelLetters[2], hint: $hint3)
                        .padding()
                    Spacer()
                }
                VStack{
                    Wheel(selectedLetter: $letter4, freeLetter: freeLetter, letters: wheelLetters[3], hint: $hint4)
                        .padding()
                    Spacer()
                }
                
            }.frame(maxHeight: .infinity)

            HStack{
                Text(letter1)
                    .font(.title)
                Text(letter2)
                    .font(.title)
                Text(letter3)
                    .font(.title)
                Text(letter4)
                    .font(.title)
                
            }.padding()
            Button(action: {
                 if isButtonActive {
                     startCountdown()
                     switch hintState {
                     case 0:
                         hint1 = ("\(viewModel.gameWords[state].word[0])".capitalized)
                     case 1:
                         hint2 = ("\(viewModel.gameWords[state].word[1])".capitalized)
                     case 2:
                         hint3 = ("\(viewModel.gameWords[state].word[2])".capitalized)
                     case 3:
                         hint4 = ("\(viewModel.gameWords[state].word[3])".capitalized)
                     default:
                         print("")
                     }
                     hintState += 1

                 }
             }) {
                 HStack{
                     Text("\(countdown)")
                         .font(.system(size: 20))
                     Text("Hint")
                         .padding()
                         .foregroundColor(.white)
                         .background(isButtonActive ? Color.blue : Color.gray)
                         .cornerRadius(10)
                 }.frame(width: 200)
      
             }
             .disabled(!isButtonActive)
            Button{
                let combined = letter1 + letter2 + letter3 + letter4
                if LocalDictionary.shared.isWordInEnglishDictionary(word: combined) {
                    if(!solvedWords.contains(combined)){
                        solvedWords.append(combined)
                        AudioServicesPlaySystemSound(1305)

                        if(state < viewModel.gameWords.count - 1){
                            state += 1
                            hintState = 0
                            hint1 = nil
                            hint2 = nil
                            hint3 = nil
                            hint4 = nil
                            
                            startCountdown()
                        }else{
                            showingAlert = true
                        }
                        print("State updated to \(state)")
                    }
                } else {
                    print("\(combined) is not a valid English word.")
                }
            }label:{
                Text("Submit")
                    .font(.title)
                
            }.padding()
        }.onAppear(){
            wheelLetters = viewModel.generateLetters()
            letter1 = wheelLetters[0][0]

            letter2 = wheelLetters[1][0]
  
            letter3 = wheelLetters[2][0]
  

            letter4 = wheelLetters[3][0]
            startCountdown()
            
        }
        .alert("WIN", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {
                viewModel = LocalDictionary()
                wheelLetters = viewModel.generateLetters()
                
            }
        }
    }
}

#Preview {
    ContentView()
}
