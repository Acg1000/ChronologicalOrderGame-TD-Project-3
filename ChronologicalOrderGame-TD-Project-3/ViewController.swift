//
//  ViewController.swift
//  ChronologicalOrderGame-TD-Project-3
//
//  Created by Andrew Graves on 5/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Labels
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var Label3: UILabel!
    @IBOutlet weak var Label4: UILabel!
    
    // Buttons
    @IBOutlet weak var Label1Button: UIButton!
    @IBOutlet weak var Label2ButtonUp: UIButton!
    @IBOutlet weak var Label2ButtonDown: UIButton!
    @IBOutlet weak var Label3ButtonUp: UIButton!
    @IBOutlet weak var Label3ButtonDown: UIButton!
    @IBOutlet weak var Label4Button: UIButton!
    
    
    let bandGameManager = BandGameManager()
    var gameSets = [Problem]()
    
    // this is the set that the user creates when they move things around
//    var currentSet =
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictonary(fromFile: "GameEvents", ofType: "plist")
            let eventsCollection = try EventUnarchiver.events(fromDictionary: dictionary)
            
            // Fills the sets with the data in the spreadsheet
            bandGameManager.sets = eventsCollection
            bandGameManager.generateQuestions(count: 3, upperBound: 3)
            
        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameSets = bandGameManager.selectedSets
        setUpLabels()
        self.becomeFirstResponder()
        
        displayProblem()
        
        print(bandGameManager.sets)
        print("View loaded this is epic")        
        // Display the first question
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            // collect all the answers and send it to be checked
            if let event1 = Label1.text, let event2 = Label2.text, let event3 = Label3.text, let event4 = Label4.text {
                let currentSelection: [String] = [event1, event2, event3, event4]
                
                if bandGameManager.checkAnswers(userEvents: currentSelection) {
                    print("correct")
                } else {
                    print("false")
                }
            } else {
                // some label is not populated
                //FIXME: This is broken
            }
        }
    }

    func displayProblem() {
        let currentRound = bandGameManager.currentRound
        let currentProblem = gameSets[currentRound]
        let currentSet = currentProblem.events
        
        Label1.text = currentSet[0].title
        Label2.text = currentSet[1].title
        Label3.text = currentSet[2].title
        Label4.text = currentSet[3].title

        // Start the timer
        
    }
    
    // This just rounds all the corners
    func setUpLabels() {
        Label1.layer.cornerRadius = 10
        Label1.clipsToBounds = true
        
        Label2.layer.cornerRadius = 10
        Label2.clipsToBounds = true
        
        Label3.layer.cornerRadius = 10
        Label3.clipsToBounds = true
        
        Label4.layer.cornerRadius = 10
        Label4.clipsToBounds = true
        
        
        
        Label1Button.layer.cornerRadius = 10
        Label1Button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        Label1Button.clipsToBounds = true
        
        Label2ButtonUp.layer.cornerRadius = 10
        Label2ButtonUp.layer.maskedCorners = [.layerMaxXMinYCorner]
        Label2ButtonUp.clipsToBounds = true
        
        Label2ButtonDown.layer.cornerRadius = 10
        Label2ButtonDown.layer.maskedCorners = [.layerMaxXMaxYCorner]
        Label2ButtonDown.clipsToBounds = true
        
        Label3ButtonUp.layer.cornerRadius = 10
        Label3ButtonUp.layer.maskedCorners = [.layerMaxXMinYCorner]
        Label3ButtonUp.clipsToBounds = true
        
        Label3ButtonDown.layer.cornerRadius = 10
        Label3ButtonDown.layer.maskedCorners = [.layerMaxXMaxYCorner]
        Label3ButtonDown.clipsToBounds = true

        Label4Button.layer.cornerRadius = 10
        Label4Button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        Label4Button.clipsToBounds = true
    }
    
    
    @IBAction func buttonsClicked(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        print(button.tag)
        switch button.tag {
        case 0: changePosition(position: 0, direction: .down)
        case 1: changePosition(position: 1, direction: .up)
        case 2: changePosition(position: 2, direction: .down)
        case 3: changePosition(position: 3, direction: .up)
        case 4: changePosition(position: 4, direction: .down)
        case 5: changePosition(position: 5, direction: .up)
        default: return
        }
//        switch button.tag {
//        case 0: print("0")
//        case 1: print("1")
//        case 2: print("2")
//        case 3: print("3")
//        case 4: print("4")
//        case 5: print("5")
//        default: return
//        }
        
    }
    
    func changePosition(position: Int, direction: MovementDirections) {
        switch direction {
        case .up:
            switch position {
            case 0: return
            case 1:
                let topText = Label1.text
                Label1.text = Label2.text
                Label2.text = topText
            case 2: return
            case 3:
                let topText = Label2.text
                Label2.text = Label3.text
                Label3.text = topText
            case 4: return
            case 5:
                let topText = Label3.text
                Label3.text = Label4.text
                Label4.text = topText
            default: return
            }
        case .down:
            switch position {
            case 0:
                let bottomText = Label2.text
                Label2.text = Label1.text
                Label1.text = bottomText
            case 1: return
            case 2:
                let bottomText = Label3.text
                Label3.text = Label2.text
                Label2.text = bottomText
            case 3: return
            case 4:
                let bottomText = Label4.text
                Label4.text = Label3.text
                Label3.text = bottomText
            case 5: return
            default: return
            }
        }
    }
}

