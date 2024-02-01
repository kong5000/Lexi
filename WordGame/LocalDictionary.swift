//
//  Dictionary.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import Foundation

struct Word {
    var word: String
    var hint: String
}



class LocalDictionary {
    static let shared = LocalDictionary()
    private var words = [Word]()
    var gameWords = [Word]()
    private let englishWords: Set<String>
    private let commonWords: Set<String>


    init() {
        // Load the local dictionary file into a Set
        if let path = Bundle.main.path(forResource: "4_letter_words", ofType: "txt"),
           let words = try? String(contentsOfFile: path) {
            englishWords = Set(words.lowercased().components(separatedBy: .newlines))
        } else {
            englishWords = Set()
        }
        
        if let path = Bundle.main.path(forResource: "4_letter_common", ofType: "txt"),
           let words = try? String(contentsOfFile: path) {
            commonWords = Set(words.lowercased().components(separatedBy: .newlines))
        } else {
            commonWords = Set()
        }
        
        if let fileURL = Bundle.main.url(forResource: "4_letter_word_hints_no_duplicates", withExtension: "csv"),
           let content = try? String(contentsOf: fileURL) {
            let lines = content.components(separatedBy: "\n")

            for line in lines {
                let components = line.components(separatedBy: ",")
                if components.count == 2 {
                    let word = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let hint = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    words.append(Word(word: word, hint: hint))
                }
            }
        }
        
        for _ in 0...4{
            gameWords.append(drawWordHints())
        }
    }
    
    func drawWordHints() -> Word {
        guard let selectedWord = words.randomElement() else {
            return Word(word:"cats", hint: "Felines")
        }

        // Remove the selected word from the array to avoid duplicates
        if let index = words.firstIndex(where: { $0.word == selectedWord.word }) {
            words.remove(at: index)
        }

        return selectedWord
    }

    func isWordInEnglishDictionary(word: String) -> Bool {
        return englishWords.contains(word.lowercased())
    }
    
    func drawRandom4LetterWord() -> String? {
        return englishWords.randomElement()?.capitalized
    }
    
    func drawRandomCommon4LetterWord() -> String? {
        return commonWords.randomElement()?.capitalized
    }
        
    
    func generateLetters() -> [[String]] {
        var res = [[String](),[String](),[String](),[String]()]
        for word in gameWords{
            var count = 0
            print(word.word)
            for char in word.word{
                if(!res[count].contains("\(char)".capitalized)){
                    res[count].append("\(char)".capitalized)
                }
                count += 1
            }
            count = 0
        }
  
        for index in res.indices {
            res[index].shuffle()
            while res[index].count < 4 {
                // Generate a random uppercase letter
                let randomLetter = String(UnicodeScalar(Int.random(in: 65...90))!)
                
                // Add the letter if it's not already in res[index]
                if !res[index].contains(randomLetter) {
                    res[index].append(randomLetter)
                }
            }
        }

        return res
        
    }
}
