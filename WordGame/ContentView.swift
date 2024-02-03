//
//  ContentView.swift
//  WordGame
//
//  Created by k on 2024-02-02.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var themeManager = ThemeManager()

    var body: some View {
        NavigationStack{
            ZStack{
                themeManager.accentColor.ignoresSafeArea()
                VStack{
                    Text("L E X I")
                        .font(.system(size: 90))
                        .foregroundColor(themeManager.themeColor)
                        .padding(.bottom, 70)
                    NavigationLink(destination: GameView()
                        .navigationBarBackButtonHidden(true) 
                        .navigationBarItems(leading: CustomBackButton())
                    ){
                        CircleButton(text: "PLAY")
                        }.padding(.bottom, 70)
                    CircleButton(text: "OFF-LINE")
                        .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                    HStack{
                        Spacer()
                        NavigationLink(destination: SettingsView()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: CustomBackButton())
                            ){
                                SettingButton()
                            }
                        
                        Spacer()
                        Image(systemName: "info.circle")
                            .font(.system(size: 80))
                            .foregroundColor(themeManager.themeColor)
                        Spacer()
                    }
                }
            }
        }
        
        .accentColor(themeManager.themeColor)
    }
}

#Preview {
    ContentView()
}
