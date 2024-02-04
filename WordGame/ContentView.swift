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
        .onAppear(){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"
                lastLogin = dateFormatter.string(from: Date())
        }
        .accentColor(themeManager.themeColor)
    }
}

#Preview {
    ContentView()
}
