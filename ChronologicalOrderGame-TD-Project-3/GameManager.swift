//
//  GameManager.swift
//  ChronologicalOrderGame-TD-Project-3
//
//  Created by Andrew Graves on 5/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import Foundation

//protocol ChronologicalOrderGame {
//    // have an array of sets
//    var ChronologicalSets: [ChronologicalOrderSet] { get }
//
//    // a round number
//    var currentRound: Int { get set }
//
//    // a round counter
//    var rounds: Int { get }
//
//    //An init that takes in an array of sets and assigns it to a let
//    init(set: [ChronologicalOrderSet])
//
//    // a function that starts the game
//    func startGame()
//
//    // a function that resets the game
//    func resetGame()
//
//    // a function that adds one to the score if the answer is correct and moves to the next round
//    func IncrementScore()
//
//}

// MARK: Game Manager Protocal

protocol GameManager {
    var sets: [ChronologicalOrderSet] { get }
    var rounds: Int { get }
    var currentRound: Int { get set }
    var score: Int { get set }
    
    init(sets: [ChronologicalOrderSet], rounds: Int)
    func resetGame()
    func incrementScore()
    
}


// MARK: enum for tracking errors with PList conversion

enum EventError: Error {
    case invalidResource
    case conversionFailure
}


//------------------------------------------------
// MARK: PLIST CONVERSION AND EXTRACTION
//------------------------------------------------


// MARK: Converts the PList to a usuable dictionary

class PlistConverter {
    static func dictonary(fromFile name: String, ofType type: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw EventError.invalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw EventError.conversionFailure
        }
        
        return dictionary
    }
}

// MARK: Takes the dictionary and returns a collection of BandItems

class EventUnarchiver {
    static func events(fromDictionary dictionary: [String: AnyObject]) throws -> [BandItem] {
        // Create my vars
        var totalEvents = [BandItem]()
        var bandItem: BandItem
        var bandInfoItems = [BandInfoItem]()
        
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any] {
                for (key2, value2) in itemDictionary {
                    
                    // Safely takes the information from the dictionary
                    if let factData = value2 as? [String: Any], let position = factData["position"] as? Int, let link = factData["url"] as? String , let factName = key2 as? String {
                        let bandInfoItem = BandInfoItem(title: factName, position: position, link: link)
                        
                        // Adds this item to the list of items
                        bandInfoItems.append(bandInfoItem)
                    }
                    
                }
                
                
                guard let bandName = BandNames(rawValue: key) else {
                    throw EventError.conversionFailure
                    //FIXME: more detailed error
                }
                
                // Creates a BandItem instance and adds that to the master collection to return
                bandItem = BandItem(name: bandName, information: bandInfoItems)
                totalEvents.append(bandItem)

            }
        }
        // Returns the collection
        return totalEvents
    }
}


class BandGameManager: GameManager {
    var sets: [ChronologicalOrderSet]
    var rounds: Int
    var currentRound: Int
    var score: Int
    
    required init(sets: [ChronologicalOrderSet], rounds: Int) {
        self.sets = sets
        self.rounds = rounds
        score = 0
        currentRound = 0
    }
    
    func resetGame() {
        
    }
    
    func incrementScore() {
        
    }
    
    
    
}
