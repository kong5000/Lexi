//
//  ScrolSnap.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import SwiftUI

struct ScrolSnap: View {
    @State private var selectedLetterIndex: Int?
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(0..<10) { i in
                    if let unwrappedIndex1 = selectedLetterIndex {
                        Text("\(unwrappedIndex1)")
                    }
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(hue: Double(i) / 10, saturation: 1, brightness: 1).gradient)
                        .frame(width: 100, height: 200)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $selectedLetterIndex, anchor: .center)
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.vertical, 40)
    }
}

#Preview {
    ScrolSnap()
}
