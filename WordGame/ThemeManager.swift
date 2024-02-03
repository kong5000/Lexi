//
//  ThemeManager.swift
//  WordGame
//
//  Created by k on 2024-02-03.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var themeColor: Color {
        isDarkMode ? Color.white : Color.black
    }
    
    var accentColor: Color {
        isDarkMode ? Color.black : Color.white 
    }
    
    init(){
        
    }
    
}
