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
    var isFinished: Bool { get set }
    
    func generateQuestions(count: Int, upperBound: Int)
    func resetGame()
    func incrementScore()
    
}


// enum for tracking errors with PList conversion

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

//------------------------------------------------
// MARK: BANDGAMEMANAGER CLASS
//------------------------------------------------

class BandGameManager: GameManager {
    var sets: [Problem]
    var selectedSets: [Problem]
    var rounds: Int
    var currentRound: Int
    var score: Int
    var isFinished: Bool

    
    required init() {
        self.rounds = 5
        score = 0
        currentRound = 1
        sets = [Problem]()
        selectedSets = [Problem]()
        isFinished = false
    }
    
    // when called generates questions based on how many are wanted
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
        
        // for every number in the random number collection
        for number in randomNumbers {
            
            // add a value corresponding to that random number
            selectedSets.append(sets[number])
        }
    }
    
    // When the game is reset set the score to 0 and the current round to 1
    func resetGame() {
        score = 0
        currentRound = 1
    }
    
    // adds one to the current score
    func incrementScore() {
        score += 1
    }
    
    // adds one to the current round
    func incrementRound() {
        currentRound += 1
    }
    
    // gets an ordered list of events
    func getOrderedList() -> [Int: String] {
        var counter = 1
        var orderedList: [Int: String] = [:]
        
        for event in selectedSets[currentRound - 1].events {
            
            orderedList[event.position] = event.title
            
            counter += 1
        }
        
        return orderedList
    }
    
    // compares the answers provided with an ordered list of answers
    func checkAnswers(userEvents: [Int: String]) -> Bool{
        var eventSorterCounter = 1
        var correctCounter = 0
        var orderedList = getOrderedList()
        
        // for every event in the dictionary provided by the user
        for event in userEvents {
            
            eventSorterCounter = 1
            
            // while the counter is <= the amount of events in the dictionary
            while eventSorterCounter <= userEvents.count {
                
                // If the events key (the number) is = to the counter
                if event.key == eventSorterCounter && orderedList[eventSorterCounter] == event.value {
                    
                    // print match and add one to the correct counter
                    print("Match")
                    correctCounter += 1
                    
                }
                
                eventSorterCounter += 1
            }
        }
        
        // if the correct counter is = to the amount of events...
        if correctCounter == userEvents.count {
            
            // This function returns true
            return true
        } else {
            
            return false
        }
    }
}
