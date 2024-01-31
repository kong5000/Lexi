//
//  Dictionary.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import Foundation

class LocalDictionary {
    static let shared = LocalDictionary()

    private let englishWords: Set<String>

    private init() {
        // Load the local dictionary file into a Set
        if let path = Bundle.main.path(forResource: "4_letter_words", ofType: "txt"),
           let words = try? String(contentsOfFile: path) {
            englishWords = Set(words.lowercased().components(separatedBy: .newlines))
        } else {
            englishWords = Set()
        }
    }

    func isWordInEnglishDictionary(word: String) -> Bool {
        return englishWords.contains(word.lowercased())
    }
}
