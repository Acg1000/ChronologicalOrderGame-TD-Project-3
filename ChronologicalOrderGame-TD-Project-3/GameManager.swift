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
    var isFinished: Bool

    
    required init() {
        self.rounds = 5
        score = 0
        currentRound = 1
        sets = [Problem]()
        selectedSets = [Problem]()
        isFinished = false
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
    }
    
    
    func resetGame() {
        score = 0
        currentRound = 1
    }
    
    func incrementScore() {
        score += 1
    }
    
    func incrementRound() {
        currentRound += 1
    }
    
    func getOrderedList() -> [Int: String] {
        var counter = 1
        var orderedList: [Int: String] = [:]
//        print("Sets \(sets) \n selected Sets \(selectedSets)")
        
//        for event in selectedSets {
//            let eventss = event.events[currentRound]
//            print("This is the current event \(eventss)")
//
//            if eventss.position == counter {
//                orderedList[counter] = eventss.title
//                print("This is the ordered list as its built: \(orderedList)")
//            } else {
//                print("not found")
//            }
//            counter += 1
//        }
        
        for event in selectedSets[currentRound - 1].events {
            
            orderedList[event.position] = event.title
//            print("Event Position: \(event.position) ==== Counter: \(counter)")
//            if event.position == counter {
//                print("We got a match!")
//            } else {
//                print("nope :(")
//            }
            
            counter += 1
        }
        
        print("This is the ordered List: \(orderedList)")
        return orderedList
    }
    
    func checkAnswers(userEvents: [Int: String]) -> Bool{
        var counter = 0
        var eventSorterCounter = 1
        var correctCounter = 0
        var orderedList = getOrderedList()
        print("\(userEvents) \n \(orderedList)")
        
        
        for event in userEvents {
            
            eventSorterCounter = 1
            while eventSorterCounter <= userEvents.count {
                
                print("KEY: \(event.key) ======== Event Sorter Counter: \(eventSorterCounter)")
                if event.key == eventSorterCounter {
                    
                    if orderedList[eventSorterCounter] == event.value {
                        print("Match")
                        correctCounter += 1
                    } else {
                        //FIXME: Add a thing here
                    }
                } else {
                    
                }
                
                eventSorterCounter += 1
            }
            
            counter += 1
        }
        
        if correctCounter == 4 {
            return true
        }
        
        return false
    }
}
