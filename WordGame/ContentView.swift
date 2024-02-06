//
//  ContentView.swift
//  WordGame
//
//  Created by k on 2024-02-02.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var themeManager = ThemeManager()
    @AppStorage("lastLogin") private var lastLogin = "Jan 01"
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("dailyFinishes") private var dailyFinishes = 0
    @AppStorage("tutorial") private var tutorial = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                themeManager.accentColor.ignoresSafeArea()
                VStack{
                    Spacer()
                    Text("L E X I")
                        .font(.system(size: 90))
                        .foregroundColor(themeManager.themeColor)
                        .padding(.bottom, 70)
                    Spacer()
                    
                    NavigationLink(destination: GameView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: CustomBackButton())
                    ){
                        CircleButton(text: "PLAY")
                    }.padding(.bottom, 70)
                    
                    HStack{
                        Spacer()
                        Button{
                            isDarkMode.toggle()
                        }label: {
                            Image(systemName: "circle.lefthalf.filled")
                                .font(.system(size: 80))
                                .foregroundColor(themeManager.themeColor)
                        }
                        
                        Spacer()
                        NavigationLink(destination: InfoView()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: CustomBackButton())
                        ){
                            Image(systemName: "info.circle")
                                .font(.system(size: 80))
                                .foregroundColor(themeManager.themeColor)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
            .onAppear(){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"
                lastLogin = dateFormatter.string(from: Date())
                
                if(dailyFinishes > 0){
                    tutorial = false
                }
            }
        }
        .accentColor(themeManager.themeColor)
    }
}

#Preview {
    ContentView()
}
