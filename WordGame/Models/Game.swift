//
//  Game.swift
//  WordGame
//
//  Created by k on 2024-02-12.
//

import Foundation

struct Game {
    var puzzles = [[Word]]()
    
    init(){
        puzzles = loadPuzzles()
    }
    
    
    func loadPuzzles() -> [[Word]]{
        if let url = Bundle.main.url(forResource: "generated_puzzles", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let loadedPuzzles = try decoder.decode([[Word]].self, from: data)
                return loadedPuzzles
            } catch {
                print("Error decoding JSON: \(error)")
                return [[Word]]()
            }
        } else {
            print("File not found")
            return [[Word]]()
        }
    }
}
