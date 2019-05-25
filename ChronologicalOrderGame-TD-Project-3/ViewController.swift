//
//  ViewController.swift
//  ChronologicalOrderGame-TD-Project-3
//
//  Created by Andrew Graves on 5/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let bandGameManager = BandGameManager()
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictonary(fromFile: "GameEvents", ofType: "plist")
            let eventsCollection = try EventUnarchiver.events(fromDictionary: dictionary)
            
            // Fills the sets with the data in the spreadsheet
            bandGameManager.sets = eventsCollection
            
        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(bandGameManager.sets)
        print("View loaded this is epic")        
        // Display the first question
    }

    func displayQuestion() {
//        let currentRound = bandGameManager.currentRound
        // get the questions
        // assign values to their respective views
        // Start round timer
    }

}

