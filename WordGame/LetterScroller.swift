//
//  ContentView.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import SwiftUI

struct LetterScroller: View {
    @Binding var selectedLetterIndex: Int?
    var letters: [String]
    
    var body: some View {
        VStack{
            ScrollView(showsIndicators: false){
                LazyVStack(spacing: 1){
                    Color.white
                        .frame(height: 300)
                    ForEach(0..<5){index in
                        Text(letters[index])
                            .frame(height: 30)
                            .padding()
                            .id(index)
                            .overlay{
                                if index == selectedLetterIndex{
                                    Rectangle()
                                        .stroke(Color.black, lineWidth:3)
                                }
                            }
                            .zIndex(index == selectedLetterIndex ? 100: 1)
                    }
                    Color.white
                        .frame(height: 300)
                }
                .padding()
                .scrollTargetLayout()
            }
            .scrollPosition(id: $selectedLetterIndex, anchor: .center)
            
        }
        .frame(maxHeight: .infinity) // Allow LetterScroller to take up the available height
        .onAppear(){
            selectedLetterIndex = 0
        }
        
    }
}

#Preview {
    LetterScroller(selectedLetterIndex: .constant(0), letters: ["A","B","C","D","E"])
}
