//
//  ContentView.swift
//  WordGame
//
//  Created by k on 2024-02-02.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var themeManager = ThemeManager()
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                themeManager.accentColor.ignoresSafeArea()
                VStack{
                    Spacer()
                    Text("L E X E")
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
        }
        .accentColor(themeManager.themeColor)
    }
}

#Preview {
    ContentView()
}
