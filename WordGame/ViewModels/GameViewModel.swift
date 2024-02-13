//
//  Dictionary.swift
//  WordGame
//
//  Created by k on 2024-01-31.
//

import Foundation
import SwiftUI
import AVFoundation

class GameViewModel: ObservableObject {
    @Published var secondsElapsed = 0.0
    private weak var timer: Timer?
    private var frequency = 0.1
    
    @Published private var model:Game
    @Published var requestError = false
    @Published var waitingForRequest = false
    
    private let localDataService:LocalDataService
    private let networkingService:APIService
    
    private var gameTimer = GameTimer()
    
    init(){
        model = Game()
        localDataService = LocalDataService()
        networkingService = APIService()
    }
    
    var puzzleName: String {model.puzzleName}
    var tutorialMode: Bool {model.tutorialMode}
    var practiceMode: Bool {model.practiceMode}
    var gameOver: Bool {model.gameOver}

    func endTutorialMode(){
        model.endTutorialMode()
    }
    var letter1: String {
        get {model.letter1}
        set {model.letter1 = newValue}
    }
    var letter2: String {
        get {model.letter2}
        set {model.letter2 = newValue}
    }
    var letter3: String {
        get {model.letter3}
        set {model.letter3 = newValue}
    }
    var letter4: String {
        get {model.letter4}
        set {model.letter4 = newValue}
    }
    
    var newRecord: Bool {model.newRecord}
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
    
    var hints:[String?] {model.hints}
    
    var hintButtonActive: Bool {model.hintButtonActive}
    
    var wheelLetters: [[String]] {return model.wheelLetters}
    
    var hintProgress: Double {
        Double(model.hintCountDown) / Double(model.hintSeconds)
    }
    
    var gameProgress: Double {
        Double(model.solvedWords.count) / Double(model.gameWords.count)
    }
    
    func submitWord(){
        let result =  model.submitWord()
        if(result){
            AudioServicesPlaySystemSound(1305)
        }else{
            AudioServicesPlaySystemSound(1306)
        }
        if(gameOver){
            if(!practiceMode){
                gameTimer.stopTimer()
                let payload: [String: Any] = [
                    "puzzleId": puzzleName,
                    "score": secondsElapsed,
                ]
                sendScore(payload:payload)
            }
        }
    }
    
    func startGame(){
        if(tutorialMode){
            model.startTutorialMode()
        }else if(practiceMode){
            model.startPracticeMode()
        }else{
            model.startDailyMode()
        }
        startHintCount()
        gameTimer.startTimer(){
            self.secondsElapsed += 0.1
        }
    }
    
    func sendScore(payload:[String:Any]){
        waitingForRequest = true
        model.sendScore(payload:payload){requestError, waitingForRequest in
            self.waitingForRequest = waitingForRequest
            self.requestError = requestError
        }
    }
    
    func hintIntent(){
        if hintButtonActive {
            generateHint()
            AudioServicesPlaySystemSound(1114)
        }
    }
}

