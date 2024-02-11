//
//  GameService.swift
//  WordGame
//
//  Created by k on 2024-02-11.
//

import Foundation

class GameService{
    func sendPostRequest(payload: [String:Any], completion: @escaping(Score?, Error?) -> Void) {
        guard let url = URL(string: "https://us-central1-lexi-word-game.cloudfunctions.net/updatePuzzleScore") else {
//            requestError = true
//            waitingForRequest = false
            return
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: payload)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
            
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    let place = jsonResponse?["place"] as! Int
                    let players = jsonResponse?["totalPlayers"] as! Int
                    let newScore = Score(place: place, players: players)
                    completion(newScore, nil)
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
