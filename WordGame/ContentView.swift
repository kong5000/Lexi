//
//  ContentView.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var ending = false
    @State var waterFallOpacity = 1.0
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
    
    @State private var showGame = true
    
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
        
        if let timer = countdownTimer {
            RunLoop.main.add(timer, forMode: .common)

        }

    }
    
    private func endGameCountdown() {
        countdown = 40
        
        withAnimation(.easeInOut(duration: 1)) {   // << here !!
            showGame = false
        }
     
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
                waterFallOpacity -= 0.028
            } else {
                withAnimation(.easeOut(duration: 1)){
                    showGame = true
                }
                waterFallOpacity = 1.0
                timer.invalidate()
            }
        }
    }
    
    
    
    var body: some View {
        ZStack{
            if(showGame){
                VStack {
                    Text(hint1 ?? "NONE")
                    Text("Score \(solvedWords.count)")
                        .font(.system(size: 30)) // You can adjust the size (e.g., 20) as per your requirement
                        .padding(.bottom, 10)
                    
                    
                    Text(viewModel.gameWords[state].hint)
                        .font(.system(size: 25))
                        .padding()
                    
                    
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
                        .padding(.top,50)
                    

                    HStack{
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
                            HintTimer(progress: 1 - (Double(countdown) / 10.0))
                        }
                        .disabled(!isButtonActive)
                        .padding()
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
    //                        endGameCountdown()
                            
                            
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
    }
    
}

#Preview {
    ContentView()
}


struct EmitterView: UIViewRepresentable{
    func makeUIView(context: Context) ->  UIView {
        let view = UIView()
        
        view.backgroundColor = .clear
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.emitterCells = createEmitterCells()
        emitterLayer.emitterSize = CGSize(width: 800, height:0)
        emitterLayer.emitterPosition = CGPoint(x:200, y:0)
        view.layer.addSublayer(emitterLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func createEmitterCells() -> [CAEmitterCell]{
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "A_small")?.cgImage
        cell.color = UIColor.red.cgColor
        cell.birthRate = 30.5
        cell.lifetimeRange = 100
        cell.velocity = 300
        cell.emissionLongitude = .pi
        cell.emissionRange = 0.5
        cell.spin = 10
        
        
        
        let cell3 = CAEmitterCell()
        cell3.contents = UIImage(named: "J_small")?.cgImage
        //        cell3.color = UIColor.red.cgColor
        cell3.birthRate = 30.5
        cell3.lifetimeRange = 100
        cell3.velocity = 300
        cell3.emissionLongitude = .pi
        cell3.emissionRange = 0.5
        cell3.spin = 10
        cell3.scale = 1.5
        
        return [cell, cell3]
    }
}
