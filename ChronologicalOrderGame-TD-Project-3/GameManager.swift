//
//  GameManager.swift
//  ChronologicalOrderGame-TD-Project-3
//
//  Created by Andrew Graves on 5/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import Foundation
import GameKit

// MARK: Game Manager Protocal

protocol GameManager {
    var sets: [Problem] { get }
    var selectedSets: [Problem] { get set }
    var rounds: Int { get }
    var currentRound: Int { get set }
    var score: Int { get set }
    
//    init(sets: [ChronologicalOrderSet], rounds: Int)
    func generateQuestions(count: Int, upperBound: Int)
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
    static func events(fromDictionary dictionary: [String: AnyObject]) throws -> [Problem] {
        // Create my vars
        var totalEvents = [Problem]()
        var bandItem: Problem
        var bandInfoItems = [Event]()
        
        for (key, value) in dictionary {
            if let itemDictionary = value as? [String: Any] {
                for (key2, value2) in itemDictionary {
                    
                    // Safely takes the information from the dictionary
                    if let factData = value2 as? [String: Any], let position = factData["position"] as? Int, let link = factData["url"] as? String , let factName = key2 as? String {
                        let bandEvent = BandEvent(title: factName, position: position, url: link)
                        
                        // Adds this item to the list of items
                        bandInfoItems.append(bandEvent)
                    }
                }
                
                
                guard let bandName = BandNames(rawValue: key) else {
                    throw EventError.conversionFailure
                    //FIXME: more detailed error
                }
                
                // Creates a BandItem instance and adds that to the master collection to return
                bandItem = BandProblem(events: bandInfoItems, bandName: bandName.rawValue)
                
                // Reset this array so it dosen't overflow with irrelevent data
                bandInfoItems = []
                totalEvents.append(bandItem)

            }
        }
        // Returns the collection
        return totalEvents
    }
}


class BandGameManager: GameManager {
    var sets: [Problem]
    var selectedSets: [Problem]
    var rounds: Int
    var currentRound: Int
    var score: Int
    
    required init() {
        self.rounds = 5
        score = 0
        currentRound = 0
        sets = [Problem]()
        selectedSets = [Problem]()
    }
    
    func generateQuestions(count: Int, upperBound: Int) {
        var randomNumber: Int
        var randomNumbers = [Int]()
        var counter = count
        
        // Takes the number of questions that need to be generated and creates multiple random questions from that
        while counter > 0 {
            randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: upperBound)
            
            // If the random number is not in the array then add it.
            if !randomNumbers.contains(randomNumber) {
                randomNumbers.append(randomNumber)
                counter -= 1
            }
        }
        
        print(randomNumbers)
                
        for number in randomNumbers {
            
            print("Current set \(sets[number])")
            selectedSets.append(sets[number])
        }
        print(selectedSets)
    }
    
    
    func resetGame() {
        // Clear all the information
    }
    
    func incrementScore() {
        score += 1
    }
    
    func incrementRound() {
        currentRound += 1
    }
    
    func checkAnswers(userEvents: [String]) -> Bool{
        let answerCounter = 0
        for event in userEvents {
            
            if event == selectedSets[currentRound].events[answerCounter].title {
                return true
            } else {
                return false
            }
        }
        return false
        
    }
}
