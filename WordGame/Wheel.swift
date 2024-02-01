//
//  Wheel.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import SwiftUI

struct Wheel: View {
    @Binding var selectedLetter: String
    @State private var onChangedExecuted = false
    var freeLetter: String
    var letters: [String]
    @Binding var hint: String?
    
    var body: some View {
        VStack{
            Picker("Steps", selection: $selectedLetter) {
                ForEach(letters, id: \.self) { letter in
                    Text("\(letter)")
                        .foregroundColor(letter == hint ? .blue : .black)
                        .tag(letter)
                    
                }
            }  .scaleEffect(2)
                .pickerStyle(.wheel)
        }.onChange(of: hint) {
            if let newHint = hint {
                // Programmatically set the selectedLetter to the newHint
                withAnimation{
                    selectedLetter = newHint
                }
            }
        }
    }
}

#Preview {
    Wheel(selectedLetter: .constant("A"), freeLetter: "C", letters: ["A","B","C"], hint:.constant("A"))
}
