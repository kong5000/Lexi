//
//  ContentView.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var freeLetter = "O"
    
    @State private var letters1 = ["A", "B","C", "D", "E"]
    @State private var letter1: String = "A"
    
    @State private var letters2 = ["F", "G","H", "I", "D"]
    @State private var letter2: String = "F"
    
    @State private var letters3 = ["B", "P","I", "Z", "E"]
    @State private var letter3: String = "B"
    
    @State private var letters4 = ["M", "B","C", "N", "E"]
    @State private var letter4: String = "M"
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top){
                VStack{
                    Button(action: {
                        if(!letters1.contains(freeLetter)){
                            letters1.insert(freeLetter, at:0)
                        }
                        letters2.removeAll { $0 == freeLetter }
                        letters3.removeAll { $0 == freeLetter }
                        letters4.removeAll { $0 == freeLetter }
                    }) {
                        if(letters1.contains(freeLetter)){
                            Text(freeLetter)
                                .font(.system(size: 36))
                                .frame(width: 70, height: 70)
                                .overlay{
                                    Rectangle()
                                        .stroke(Color.black, lineWidth:3)
                                }
                        }else{
                            Color.white
                                .frame(width: 70, height: 70)
                                .overlay{
                                    Rectangle()
                                        .stroke(Color.black, lineWidth:3)
                                }
                        }
                    }
                    Spacer()
                    Wheel(selectedLetter: $letter1, freeLetter: freeLetter, letters: letters1)
                        .padding()
                    Spacer()
                }
                VStack{
                    Button(action: {
                        if(!letters2.contains(freeLetter)){
                            letters2.insert(freeLetter, at:0)
                        }
                        letters1.removeAll { $0 == freeLetter }
                        letters3.removeAll { $0 == freeLetter }
                        letters4.removeAll { $0 == freeLetter }
                    }) {
                        if(letters2.contains(freeLetter)){
                            Text(freeLetter)
                                .font(.system(size: 36))
                                .frame(width: 70, height: 70)
                                .overlay{
                                    Rectangle()
                                        .stroke(Color.black, lineWidth:3)
                                }
                        }else{
                            Color.white
                                .frame(width: 70, height: 70)
                                .overlay{
                                    Rectangle()
                                        .stroke(Color.black, lineWidth:3)
                                }
                        }
                    }
                    Spacer()
                    Wheel(selectedLetter: $letter2, freeLetter: freeLetter, letters: letters2)
                        .padding()
                    Spacer()
                }
                VStack{
                    Button(action: {
                        if(!letters3.contains(freeLetter)){
                            letters3.insert(freeLetter, at:0)
                        }
                        letters2.removeAll { $0 == freeLetter }
                        letters1.removeAll { $0 == freeLetter }
                        letters4.removeAll { $0 == freeLetter }
                    }) {
                        if(letters3.contains(freeLetter)){
                            Text(freeLetter)
                                .font(.system(size: 36))
                                .frame(width: 70, height: 70)
                                .overlay{
                                    Rectangle()
                                        .stroke(Color.black, lineWidth:3)
                                }
                        }else{
                            Color.white
                                .frame(width: 70, height: 70)
                                .overlay{
                                    Rectangle()
                                        .stroke(Color.black, lineWidth:3)
                                }
                        }
                    }
                    Spacer()
                    Wheel(selectedLetter: $letter3, freeLetter: freeLetter, letters: letters3)
                        .padding()
                    Spacer()
                }
                VStack{
                    Button(action: {
                        if(!letters4.contains(freeLetter)){
                            letters4.insert(freeLetter, at:0)
                        }
                        letters2.removeAll { $0 == freeLetter }
                        letters3.removeAll { $0 == freeLetter }
                        letters1.removeAll { $0 == freeLetter }
                    }) {
                        if(letters4.contains(freeLetter)){
                            Text(freeLetter)
                                .font(.system(size: 36))
                                .frame(width: 70, height: 70)
                                .overlay{
                                    Rectangle()
                                        .stroke(Color.black, lineWidth:3)
                                }
                        }else{
                            Color.white
                                .frame(width: 70, height: 70)
                                .overlay{
                                    Rectangle()
                                        .stroke(Color.black, lineWidth:3)
                                }
                        }
                    }
                    Spacer()
                    Wheel(selectedLetter: $letter4, freeLetter: freeLetter, letters: letters4)
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
            Button{
                let combined = letter1 + letter2 + letter3 + letter4
                if LocalDictionary.shared.isWordInEnglishDictionary(word: combined) {
                    print("\(combined) is a valid English word.")
                    showingAlert = true
                } else {
                    print("\(combined) is not a valid English word.")
                }
            }label:{
                Text("Submit")
                    .font(.title)

            }.padding()
        }.onAppear(){
            letters1.insert(freeLetter, at:0)
        }
        .alert("\(letter1 + letter2 + letter3 + letter4) is the word!", isPresented: $showingAlert) {

                   Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    ContentView()
}
