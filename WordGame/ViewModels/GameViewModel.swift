//
//  Dictionary.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import Foundation
import SwiftUI


class GameViewModel: ObservableObject {
    private static let GAME_LENGTH = 8
    private let localDataService = LocalDataService()
    private let networkingService = APIService()
    
    private var hintSeconds = 10
    private var practiceMode = false
    private var tutorialMode = false
    
    private var words = [Word]()
    private var solvedWords = [String]()
    private var puzzles = [[Word]]()
    var questionIndex = 0
    
    var letter1: String = ""
    var letter2: String = ""
    var letter3: String = ""
    var letter4: String = ""
    
    @Published var hints: [String?] = [nil,nil,nil,nil]

    var hintState: Int = 0
    var hintButtonActive = false
    var hintCountDownTimer: Timer?
    var hintCountDown = 0
    
    private var hintIndexes = [0,1,2,3]
    
    private var previousTopFinish: Int
    
    @Published var requestError = false
    @Published var waitingForRequest = false
    @Published var resultText = ""
    @Published var newRecord = false
    
    var hintProgress: Double {
        Double(hintCountDown) / Double(hintSeconds)
    }
    
    var gameProgress: Double {
        Double(solvedWords.count) / Double(gameWords.count)
    }
    
    var wheelLetters = [[String](),[String](),[String](),[String]()]
    
    var gameWords = [Word]()
    
    init() {
        previousTopFinish = localDataService.getTopFinish()
        if let url = Bundle.main.url(forResource: "generated_puzzles", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                puzzles = try decoder.decode([[Word]].self, from: data)
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
    }
    
    private func drawWordHints() -> Word {
        guard let selectedWord = words.randomElement() else {
            return Word(word:"cats", hint: "Felines")
        }
        
        // Remove the selected word from the array to avoid duplicates
        if let index = words.firstIndex(where: { $0.word == selectedWord.word }) {
            words.remove(at: index)
        }
        
        return selectedWord
    }
    
    private func generateLetters() -> [[String]] {
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
        if !hintIndexes.isEmpty {
            let randomIndex = Int.random(in: 0..<hintIndexes.count)
            let randomHint = hintIndexes[randomIndex]
            hintIndexes.remove(at: randomIndex)
            
            hints[randomHint] = ("\(gameWords[questionIndex].word[randomHint])".capitalized)
            
            hintState += 1
            
            startHintCount()
        }
    }
    
    private func resetHints(){
        hintIndexes = [0,1,2,3]
        hints = [nil,nil,nil,nil]
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
            if self.hintCountDown < self.hintSeconds - 1 {
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
    
    private func resetState(){
        resetHints()
        questionIndex = 0
        solvedWords = [String]()
    }
    
    func startTutorialMode(){
        resetState()
        
        hintSeconds = 5
        
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
    }
    
    func startDailyMode(){
        resetState()
        
        hintSeconds = 10
        
        let currentDate = Date()
        let calendar = Calendar.current
        if let dayOfYear = calendar.ordinality(of: .day, in: .year, for: currentDate) {
            gameWords = puzzles[dayOfYear % puzzles.count]
        } else {
            print("Error calculating day of the year")
        }
        
        wheelLetters = generateLetters()
        letter1 = wheelLetters[0][0]
        letter2 = wheelLetters[1][0]
        letter3 = wheelLetters[2][0]
        letter4 = wheelLetters[3][0]
    }
    
    func startPracticeMode(){
        resetState()
        
        practiceMode = true
        gameWords = [Word]()
        
        for _ in 0..<GameViewModel.GAME_LENGTH{
            gameWords.append(drawWordHints())
        }
        
        hintSeconds = 10
        
        wheelLetters = generateLetters()
        letter1 = wheelLetters[0][0]
        letter2 = wheelLetters[1][0]
        letter3 = wheelLetters[2][0]
        letter4 = wheelLetters[3][0]
    }
    
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
    
    func sendScore(payload:[String:Any]){
        self.waitingForRequest = true
        
        networkingService.sendPostRequest(payload: payload){newScore, error in
            if let newScore = newScore {
                DispatchQueue.main.async{
                    self.requestError = false
                    self.resultText = "\(self.ordinalNumber(newScore.place)) out of \(newScore.players) players"
                    if(newScore.place <= 10){
                        self.localDataService.newTop10()
                    }else if(newScore.place <= 100){
                        self.localDataService.newTop100()
                    }
                    self.localDataService.newDailyFinish()
                    if(newScore.place < self.previousTopFinish){
                        self.localDataService.newTopFinish(place:newScore.place)
                        self.newRecord = true
                    }
                    self.waitingForRequest = false
                }
            }else{
                DispatchQueue.main.async{
                    self.requestError = true
                    self.waitingForRequest = false
                }
            }
        }
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