//
//  Dictionary.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import Foundation

let GAME_LENGTH = 7
var HINT_SECONDS = 10

struct Word: Decodable {
    var word: String
    var hint: String
}

typealias Puzzle = [Word]

class GameViewModel {
    private var practiceMode = false
    private var tutorialMode = false
    static let shared = GameViewModel()
    private var words = [Word]()
    private var solvedWords = [String]()
    var questionIndex = 0
    
    var letter1: String = ""
    var letter2: String = ""
    var letter3: String = ""
    var letter4: String = ""
    
    var hint1: String? = nil
    var hint2: String? = nil
    var hint3: String? = nil
    var hint4: String? = nil
    
    var hintState: Int = 0
    
    var hintButtonActive = false
    
    var hintCountDownTimer: Timer?
    var hintCountDown = 0
    
    var hintProgress: Double {
        Double(hintCountDown) / Double(HINT_SECONDS)
    }
    
    var gameProgress: Double {
        Double(solvedWords.count) / Double(gameWords.count)
    }

    var wheelLetters = [[String](),[String](),[String](),[String]()]
    
    var gameWords = [Word]()
    
    init() {
        if let url = Bundle.main.url(forResource: "generated_puzzles", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let puzzles = try decoder.decode([[Word]].self, from: data)
                let currentDate = Date()

                // Create a calendar instance
                let calendar = Calendar.current

                // Get the day of the year
                if let dayOfYear = calendar.ordinality(of: .day, in: .year, for: currentDate) {
                    gameWords = puzzles[dayOfYear % puzzles.count]

                } else {
                    print("Error calculating day of the year")
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("File not found")
        }
        
        if let fileURL = Bundle.main.url(forResource: "4_letter_word_hints_no_duplicates", withExtension: "csv"),
           let content = try? String(contentsOf: fileURL) {
            let lines = content.components(separatedBy: "\n")
            
            for line in lines {
                let components = line.components(separatedBy: "/")
                if components.count == 2 {
                    let word = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let hint = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    words.append(Word(word: word, hint: hint))
                }
            }
        }
        
        reset()
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
    
    func generateLetters() -> [[String]] {
        var res = [[String](),[String](),[String](),[String]()]
        for word in gameWords{
            var count = 0
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
            while res[index].count < 3 {
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
    
    func generateHint(){
        switch hintState {
            case 0:
                hint1 = ("\(gameWords[questionIndex].word[0])".capitalized)
            case 1:
                hint2 = ("\(gameWords[questionIndex].word[1])".capitalized)
            case 2:
                hint3 = ("\(gameWords[questionIndex].word[2])".capitalized)
            case 3:
                hint4 = ("\(gameWords[questionIndex].word[3])".capitalized)
            default:
                print("")
            }
            hintState += 1
        
        startHintCount()
    }
    
    func resetHints(){
        hintState = 0
        hint1 = nil
        hint2 = nil
        hint3 = nil
        hint4 = nil
    }
    
    func reset(){
        HINT_SECONDS = 10

        wheelLetters = generateLetters()
        letter1 = wheelLetters[0][0]
        letter2 = wheelLetters[1][0]
        letter3 = wheelLetters[2][0]
        letter4 = wheelLetters[3][0]
        
        resetHints()
        
        questionIndex = 0
        solvedWords = [String]()
        startHintCount()        
    }
    
    func submitWord() -> Bool{
        let combined = letter1 + letter2 + letter3 + letter4
        
        if gameWords[questionIndex].word.uppercased() == combined {
            solvedWords.append(combined)
            resetHints()
            if(questionIndex < gameWords.count - 1){
                questionIndex += 1
            }else{
                //                    End Game?
            }
            return true
        }
        return false
    }
    
    func startHintCount() {
        hintCountDownTimer?.invalidate()
        
        hintButtonActive = false
        hintCountDown = 0
        
        hintCountDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.hintCountDown < HINT_SECONDS - 1 {
                self.hintCountDown += 1

            } else {
                self.hintCountDown += 1
                self.hintButtonActive = true
                timer.invalidate()
            }
        }
        
        if let timer = hintCountDownTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    func startTutorialMode(){
        tutorialMode = true
        gameWords = [
            Word(word:"word", hint:"Scroll the letters to find the passWORD. Then submit."),
            Word(word:"hint", hint:"Get a free letter with the HINT button"),
            Word(word:"time", hint:"Try to solve the daily puzzle in the best TIME")
        ]

        wheelLetters = [["W","T","H"],["Z","O","I"],["R","N","M"],["D","T","E"] ]
        letter1 = wheelLetters[0][0]
        letter2 = wheelLetters[1][0]
        letter3 = wheelLetters[2][0]
        letter4 = wheelLetters[3][0]
        
        HINT_SECONDS = 5
    }
    
    func startPracticeMode(){
        practiceMode = true
        gameWords = [Word]()
        
        for _ in 0..<GAME_LENGTH{
            gameWords.append(drawWordHints())
        }
        
        reset()
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
