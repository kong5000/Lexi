//
//  LocalDataService.swift
//  WordGame
//
//  Created by k on 2024-02-11.
//
import SwiftUI
import Foundation

class LocalDataService{
    @AppStorage("top10") private var top10Finishes = 0
    @AppStorage("top100") private var top100Finishes = 0
    @AppStorage("dailyFinishes") private var dailyFinishes = 0
    @AppStorage("topFinish") private var topFinish = 999999
    @AppStorage("tutorial") var tutorialMode = true
    
    func getTopFinish() -> Int{
        return topFinish
    }
    
    func newTop10(){
        top10Finishes += 1
    }
    
    func newTop100(){
        top100Finishes += 1
    }
    
    func newDailyFinish(){
        dailyFinishes += 1
    }
    
    func newTopFinish(place: Int){
        topFinish = place
    }
    
    func setTutorialMode(active: Bool){
        tutorialMode = active
    }
}
