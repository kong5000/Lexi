//
//  Word.swift
//  WordGame
//
//  Created by k on 2024-02-11.
//

import Foundation

struct Word: Decodable {
    var word: String
    var hint: String
}

typealias Puzzle = [Word]
