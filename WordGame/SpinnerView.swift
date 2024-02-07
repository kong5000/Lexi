//
//  SpinnerView.swift
//  WordGame
//
//  Created by k on 2024-02-04.
//

import SwiftUI

struct SpinnerView: View {
  var body: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle(tint: .blue))
  }
}
#Preview {
    SpinnerView()
}
