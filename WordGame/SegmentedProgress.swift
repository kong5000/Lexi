//
//  SegmentedProgress.swift
//  WordGame
//
//  Created by k on 2024-02-02.
//

import SwiftUI

struct SegmentedProgress: View {
    var progress = 0.0
    var body: some View {
        VStack {
            ProgressView(value: progress)
                .tint(.black)
        }
    }
    
}

#Preview {
    SegmentedProgress()
}
