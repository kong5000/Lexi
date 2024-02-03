//
//  SwiftUIView.swift
//  WordGame
//
//  Created by k on 2024-02-03.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding()

            Text("Hello, World!")
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    SettingsView()
}
