//
//  SegmentedProgress.swift
//  WordGame
//
//  Created by k on 2024-02-02.
//

import SwiftUI

struct SegmentedProgress: View {
    @StateObject private var themeManager = ThemeManager()

    var progress = 0.0
    var body: some View {
        VStack {
            ProgressView(value: progress)
                .tint(themeManager.themeColor)
        }
    }
    
}

#Preview {
    SegmentedProgress()
}
