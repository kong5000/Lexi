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
    
    
    @State private var letters1 = [String]()
    @State private var letter1: String = ""
    
    @State private var letters2 = ["F", "E","H", "I", "D"]
    @State private var letter2: String = "E"
    
    @State private var letters3 = ["I", "P","X", "Z", "E"]
    @State private var letter3: String = "X"
    
    @State private var letters4 = ["K", "B","C", "I", "E"]
    @State private var letter4: String = "I"
    
    @State private var state: Int = 0
    
    @State private var viewModel = LocalDictionary()
    
    
    var body: some View {
        VStack {
            Text(viewModel.gameWords[state].hint)
                .font(.system(size: 20)) // You can adjust the size (e.g., 20) as per your requirement
            //            Text(viewModel.gameWords[state].word)
            
            HStack(alignment: .top){
                VStack{
//                    Button(action: {
//                        if(!letters1.contains(freeLetter)){
//                            letters1.insert(freeLetter, at:0)
//                        }
//                        letters2.removeAll { $0 == freeLetter }
//                        letters3.removeAll { $0 == freeLetter }
//                        letters4.removeAll { $0 == freeLetter }
//                    }) {
//                        if(letters1.contains(freeLetter)){
//                            Text(freeLetter)
//                                .font(.system(size: 36))
//                                .frame(width: 70, height: 70)
//                                .overlay{
//                                    Rectangle()
//                                        .stroke(Color.black, lineWidth:3)
//                                }
//                        }else{
//                            Color.white
//                                .frame(width: 70, height: 70)
//                                .overlay{
//                                    Rectangle()
//                                        .stroke(Color.black, lineWidth:3)
//                                }
//                        }
//                    }.padding(.bottom, 80)
                    Wheel(selectedLetter: $letter1, freeLetter: freeLetter, letters: wheelLetters[0])
                        .padding()
                    Spacer()
                }
                VStack{
//                    Button(action: {
//                        if(!letters2.contains(freeLetter)){
//                            letters2.insert(freeLetter, at:0)
//                        }
//                        letters1.removeAll { $0 == freeLetter }
//                        letters3.removeAll { $0 == freeLetter }
//                        letters4.removeAll { $0 == freeLetter }
//                    }) {
//                        if(letters2.contains(freeLetter)){
//                            Text(freeLetter)
//                                .font(.system(size: 36))
//                                .frame(width: 70, height: 70)
//                                .overlay{
//                                    Rectangle()
//                                        .stroke(Color.black, lineWidth:3)
//                                }
//                        }else{
//                            Color.white
//                                .frame(width: 70, height: 70)
//                                .overlay{
//                                    Rectangle()
//                                        .stroke(Color.black, lineWidth:3)
//                                }
//                        }
//                    }.padding(.bottom, 80)
                    Wheel(selectedLetter: $letter2, freeLetter: freeLetter, letters: wheelLetters[1])
                        .padding()
                    Spacer()
                }
                VStack{
//                    Button(action: {
//                        if(!letters3.contains(freeLetter)){
//                            letters3.insert(freeLetter, at:0)
//                        }
//                        letters2.removeAll { $0 == freeLetter }
//                        letters1.removeAll { $0 == freeLetter }
//                        letters4.removeAll { $0 == freeLetter }
//                    }) {
//                        if(letters3.contains(freeLetter)){
//                            Text(freeLetter)
//                                .font(.system(size: 36))
//                                .frame(width: 70, height: 70)
//                                .overlay{
//                                    Rectangle()
//                                        .stroke(Color.black, lineWidth:3)
//                                }
//                        }else{
//                            Color.white
//                                .frame(width: 70, height: 70)
//                                .overlay{
//                                    Rectangle()
//                                        .stroke(Color.black, lineWidth:3)
//                                }
//                        }
//                    }.padding(.bottom, 80)
                    Wheel(selectedLetter: $letter3, freeLetter: freeLetter, letters: wheelLetters[2])
                        .padding()
                    Spacer()
                }
                VStack{
//                    Button(action: {
//                        if(!letters4.contains(freeLetter)){
//                            letters4.insert(freeLetter, at:0)
//                        }
//                        letters2.removeAll { $0 == freeLetter }
//                        letters3.removeAll { $0 == freeLetter }
//                        letters1.removeAll { $0 == freeLetter }
//                    }) {
//                        if(letters4.contains(freeLetter)){
//                            Text(freeLetter)
//                                .font(.system(size: 36))
//                                .frame(width: 70, height: 70)
//                                .overlay{
//                                    Rectangle()
//                                        .stroke(Color.black, lineWidth:3)
//                                }
//                        }else{
//                            Color.white
//                                .frame(width: 70, height: 70)
//                                .overlay{
//                                    Rectangle()
//                                        .stroke(Color.black, lineWidth:3)
//                                }
//                        }
//                    }.padding(.bottom, 80)
                    Wheel(selectedLetter: $letter4, freeLetter: freeLetter, letters: wheelLetters[3])
                        .padding()
                    Spacer()
                }
                
            }.frame(maxHeight: .infinity)
            Text("Score \(solvedWords.count)")
                .font(.system(size: 30)) // You can adjust the size (e.g., 20) as per your requirement
                .padding()
            

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
            Button{
                let combined = letter1 + letter2 + letter3 + letter4
                if LocalDictionary.shared.isWordInEnglishDictionary(word: combined) {
                    if(!solvedWords.contains(combined)){
                        solvedWords.append(combined)
                        AudioServicesPlaySystemSound(1305)

                        if(state < viewModel.gameWords.count - 1){
                            state += 1
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
            
            letters1.insert(freeLetter, at:0)
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
