//
//  Dictionary.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import Foundation
import SwiftUI


class GameViewModel: ObservableObject {
    private var model = Game()
    private let localDataService = LocalDataService()
    private let networkingService = APIService()
    
    private var puzzles: [[Word]]{
        model.puzzles
    }
    
    
    var letter1: String {
        get {
            return model.letter1
        }
        set {
            model.letter1 = newValue
        }
    }
    var letter2: String {
        get {
            return model.letter2
        }
        set {
            model.letter2 = newValue
        }
    }
    var letter3: String {
        get {
            return model.letter3
        }
        set {
            model.letter3 = newValue
        }
    }
    var letter4: String {
        get {
            return model.letter4
        }
        set {
            model.letter4 = newValue
        }
    }
        
    
    var requestError: Bool{
        model.requestError
    }
    var waitingForRequest: Bool{
        model.waitingForRequest
    }
    var newRecord: Bool{
        model.newRecord
    }
    var resultText: String{
        return "\(Utilities.ordinalNumber(model.place)) out of \(model.players) players"
    }
    func startHintCount(){
        model.startHintCount()
    }
    
    func generateHint(){
        model.generateHint()
    }
    
    var currentWord:Word{
        model.gameWords[model.questionIndex]
    }
    
    var hints:[String?]{
        model.hints
    }
    
    var hintButtonActive: Bool {
        model.hintButtonActive
    }
    
    var hintProgress: Double {
        Double(model.hintCountDown) / Double(model.hintSeconds)
    }
    
    var gameProgress: Double {
        Double(model.solvedWords.count) / Double(model.gameWords.count)
    }
        
    var gameWords: [Word] {
        return model.gameWords
    }
    
    var wheelLetters: [[String]]{
        return model.wheelLetters
    }


    func submitWord() -> Bool{
        return model.submitWord()
    }

    func startTutorialMode(){
        model.startTutorialMode()
    }
    
    func startDailyMode(){
        model.startDailyMode()
    }
    
    func startPracticeMode(){
        model.startPracticeMode()
    }
    
    func sendScore(payload:[String:Any]){
        model.sendScore(payload:payload)
    }
}

