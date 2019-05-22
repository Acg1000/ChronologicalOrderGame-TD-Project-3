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



// MARK: Converts the PList to usable resourses

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


class EventUnarchiver {
    static func events(fromDictionary dictionary: [String: AnyObject]) throws -> [BandItem] {
        var totalEvents = [BandItem]()
        var bandItem: BandItem
        var bandInfoItems = [BandInfoItem]()
        
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any] {
                if let bandData = itemDictionary as? [String: Any], let position = bandData["position"] as? Int, let link = bandData["url"] as? String {
                    
                    var bandInfoItem = BandInfoItem(position: position, link: link)
                    bandInfoItems.append(bandInfoItem)
                    
                }
                
                guard let bandName = BandNames(rawValue: key) else {
                    throw EventError.conversionFailure
                    //FIXME more detailed error
                }
                
                bandItem = BandItem(name: bandName, information: bandInfoItems)
                totalEvents.append(bandItem)

            }
//            if let itemDictionary = value as? [String: Any], let price = itemDictionary["price"] as? Double, let quantity = itemDictionary["quantity"] as? Int {
//                let item = Item(price: price, quantity: quantity)
//
//                guard let selection = VendingSelection(rawValue: key) else {
//                    throw InventoryError.invalidSelection
//                }
//
//                events.updateValue(item, forKey: selection)
//            }
        }
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
