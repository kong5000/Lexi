//
//  Game.swift
//  WordGame
//
//  Created by k on 2024-02-12.
//

import Foundation

class Game {
    private static let GAME_LENGTH = 8
    private let localDataService = LocalDataService()
    private let networkingService = APIService()
    
    var practiceMode = false
    var tutorialMode: Bool
    
    var puzzles = [[Word]]()
    var solvedWords = [String]()
    var gameWords = [Word]()
    var wheelLetters = [[String](),[String](),[String](),[String]()]
    var practiceWords = [Word]()
    
    var hintSeconds = 10
    var hintButtonActive = false
    var hintCountDownTimer: Timer?
    var hintCountDown = 0
    var hintIndexes = [0,1,2,3]
    var hints: [String?] = [nil,nil,nil,nil]
    
    var letter1 = ""
    var letter2 = ""
    var letter3 = ""
    var letter4 = ""
    
    var questionIndex = 0
    
    var newRecord = false
    var previousTopFinish: Int
    var place = 0
    var players = 0
    
    init(){
        tutorialMode = localDataService.tutorialMode
        previousTopFinish = localDataService.getTopFinish()
        loadPuzzles()
        loadPracticeWords()
    }
    
    func loadPuzzles(){
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
    }
    
    func loadPracticeWords(){
        if let fileURL = Bundle.main.url(forResource: "4_letter_word_hints_no_duplicates", withExtension: "csv"),
           let content = try? String(contentsOf: fileURL) {
            let lines = content.components(separatedBy: "\n")
            
            for line in lines {
                let components = line.components(separatedBy: "/")
                if components.count == 2 {
                    let word = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let hint = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    practiceWords.append(Word(word: word, hint: hint))
                }
            }
        }
    }
    
    func generateHint(){
        if !hintIndexes.isEmpty {
            let randomIndex = Int.random(in: 0..<hintIndexes.count)
            let randomHint = hintIndexes[randomIndex]
            hintIndexes.remove(at: randomIndex)
            
            hints[randomHint] = ("\(gameWords[questionIndex].word[randomHint])".capitalized)
            
            startHintCount()
        }
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
    func resetHints(){
        hintIndexes = [0,1,2,3]
        hints = [nil,nil,nil,nil]
    }
    
    func drawWordHints() -> Word {
        guard let selectedWord = practiceWords.randomElement() else {
            return Word(word:"cats", hint: "Felines")
        }
        
        // Remove the selected word from the array to avoid duplicates
        if let index = practiceWords.firstIndex(where: { $0.word == selectedWord.word }) {
            practiceWords.remove(at: index)
        }
        
        return selectedWord
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
    
    func resetState(){
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
        
        for _ in 0..<Game.GAME_LENGTH{
            gameWords.append(drawWordHints())
        }
        
        hintSeconds = 10
        
        wheelLetters = generateLetters()
        letter1 = wheelLetters[0][0]
        letter2 = wheelLetters[1][0]
        letter3 = wheelLetters[2][0]
        letter4 = wheelLetters[3][0]
    }
    
    func sendScore(payload:[String:Any],callback:  @escaping (_ requestError: Bool, _ waitingForRequest:Bool)-> Void){
        networkingService.sendPostRequest(payload: payload){newScore, error in
            if let newScore = newScore {
                DispatchQueue.main.async{
                    self.place = newScore.place
                    self.players = newScore.players
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
                    callback(false, false)
                }
            }else{
                DispatchQueue.main.async{
                    callback(true, false)
                }
            }
        }
    }
    
    func endTutorialMode(){
        localDataService.setTutorialMode(active: false)
    }
}
