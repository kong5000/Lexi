//
//  SwiftUIView.swift
//  WordGame
//
//  Created by k on 2024-02-05.
//

import SwiftUI

struct ScoreboardItem: View {
    var label: String
    var value: String
    let themeManager = ThemeManager()
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 24))
                .foregroundColor(themeManager.themeColor)
                .frame(width: 200, alignment: .leading)
            Spacer()
            Text(value)
                .foregroundColor(themeManager.themeColor)
                .font(.system(size: 24))
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
struct InfoView: View {
    @AppStorage("top10") private var top10Finishes = 0
    @AppStorage("top100") private var top100Finishes = 0
    @AppStorage("dailyFinishes") private var dailyFinishes = 0
    @AppStorage("topFinish") private var topFinish = 999999
    
    let themeManager = ThemeManager()
    
    func ordinalNumber(_ number: Int) -> String {
        var numberSuffix = ""
        
        switch number % 10 {
        case 1:
            numberSuffix = "st"
        case 2:
            numberSuffix = "nd"
        case 3:
            numberSuffix = "rd"
        default:
            numberSuffix = "th"
        }
        
        // Special case for numbers ending in 11, 12, and 13
        if (number % 100) / 10 == 1 {
            numberSuffix = "th"
        }
        
        return "\(number)\(numberSuffix)"
    }
    
    var body: some View {
        ZStack {
            themeManager.accentColor.ignoresSafeArea()
            VStack {
                Spacer()
                VStack {
                    if(topFinish != 999999){
                        ScoreboardItem(label: "Best Record", value: "\(ordinalNumber(topFinish)) place")
                    }
                    ScoreboardItem(label: "Top 10 Finishes", value: "\(top10Finishes)")
                    ScoreboardItem(label: "Top 100 Finishes", value: "\(top100Finishes)")
                    ScoreboardItem(label: "Daylies Completed", value: "\(dailyFinishes)")
                }.padding(.bottom, 100)
                ScoreboardItem(label: "Version", value: "1.0")
                ScoreboardItem(label: "Developer", value: " K. Ong")
                
                Link("Contact", destination: URL(string: "https://www.linkedin.com/in/keith-ong-8685a513b/")!)
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                    .padding()
                Spacer()
            }.padding()
        }
    }
}

#Preview {
    InfoView()
}
