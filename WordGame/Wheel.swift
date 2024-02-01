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
    
    var body: some View {
        VStack{
            Picker("Steps", selection: $selectedLetter) {
                    ForEach(letters, id: \.self) { letter in
                        Text("\(letter)")
                    }
                }  .scaleEffect(2)
                .pickerStyle(.wheel)

        }
   
    }
}

#Preview {
    Wheel(selectedLetter: .constant("A"), freeLetter: "C", letters: ["A","B","C"])
}
