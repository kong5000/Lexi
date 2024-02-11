//
//  CustomBackButton.swift
//  WordGame
//
//  Created by k on 2024-02-03.
//

import SwiftUI

struct CustomBackButton: View {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(themeManager.themeColor)
                .font(.system(size: 24))
                .padding()
        }
    }
}
#Preview {
    CustomBackButton()
}
