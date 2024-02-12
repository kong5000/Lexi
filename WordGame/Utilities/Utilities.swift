//
//  Utilities.swift
//  WordGame
//
//  Created by k on 2024-02-12.
//

import Foundation

class Utilities {
    static func ordinalNumber(_ number: Int) -> String {
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

        if (number % 100) / 10 == 1 {
            numberSuffix = "th"
        }

        return "\(number)\(numberSuffix)"
    }
}

extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }
    
    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }
}
