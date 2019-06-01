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
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var finishGameButton: UIButton!
    
    // Feilds
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var scoreField: UILabel!
    @IBOutlet weak var objectName: UILabel!
    
    
    let bandGameManager = BandGameManager()
    var gameSets = [Problem]()
    var currentProblemSet = [Event]()
    var isTimerOn = false
    let correctImage = UIImage(named: "next_round_success")
    let incorrectImage = UIImage(named: "next_round_fail")
    var isFinished = false
    var finalScore = ""
    var wasShook = false

    
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
        
    }
    
    //------------------------------------------------
    // MARK: APP SETUP AND PREP
    //------------------------------------------------
    
    
    // These next two things just allow for use of the device's motion sensors
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
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
        
        finishGameButton.isHidden = true

    }
    
    
//------------------------------------------------
// MARK: PROBLEM AND ROUND MANIPULATION
//------------------------------------------------
    
    // When called, changes the values of the labels to match the information passed into the Game manager
    func displayProblem() {
        let currentRound = bandGameManager.currentRound
        currentProblemSet = gameSets[currentRound - 1].events
        extraInfoLabel.text = "Shake to complete"
        timerLabel.text = "30"
        
        Label1.text = currentProblemSet[0].title
        Label2.text = currentProblemSet[1].title
        Label3.text = currentProblemSet[2].title
        Label4.text = currentProblemSet[3].title
        objectName.text = gameSets[currentRound-1].bandName
        
        nextRoundButton.isHidden = true


        // Start the timer
        print("timer started")
        
        isTimerOn = true
        self.changeButtonState(to: .enabled)
        roundTimer(currentRound: currentRound, withTimerOf: 30)
    }
    
    
    func nextRound() {
        bandGameManager.incrementRound()
        print("Current Round:  \(bandGameManager.currentRound)")
        
        print("showing problem")

        displayProblem()
    }
    
    
    // This is the main round timer logic
    func roundTimer(currentRound: Int, withTimerOf time: Int) {
        var counter = time
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(1))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            if self.isTimerOn {
                // when the counter runs to 0
                if counter == 0 {
                    
                    // if the
                    if currentRound == self.bandGameManager.currentRound {
                        
                        //TODO: Disable the buttons
                        self.changeButtonState(to: .disabled)
                        self.nextRoundButton.isHidden = false

                        self.nextRoundButton.setImage(self.incorrectImage, for: .normal)
                        
                        self.extraInfoLabel.text = "Click events for more info"
                        
                    } else {
                        print("incorrect round")
                        // Do nothing, the timer does not apply to this round
                    }
                } else {
                    
                    if currentRound == self.bandGameManager.currentRound {
                        counter -= 1
                        self.timerLabel.text = "\(counter)"
                        print(counter)
                        self.roundTimer(currentRound: currentRound, withTimerOf: counter)
                    } else {
                        // Do nothing, the timer does not apply to this round
                        print("incorrect round")
                        
                    }
                }
            }
        }
    }

    
    // The logic behind moving the different text around
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
    
    func resetGame() {
        setUpLabels()
        bandGameManager.resetGame()
        finishGameButton.isHidden = true
        isFinished = false
        
        displayProblem()
    }
    
//------------------------------------------------
// MARK: ACTION TAKEN OR BUTTON PRESS FUNCTIONS
//------------------------------------------------
    
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
    }
    
    // When a device is shook trigger the check answer
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && wasShook == false {
            
            changeButtonState(to: .disabled)
            
            // collect all the answers and send it to be checked
            if let event1 = Label1.text, let event2 = Label2.text, let event3 = Label3.text, let event4 = Label4.text {
                let currentSet = [1: event1, 2: event2, 3: event3, 4: event4]
                
                print("This is the current Round: \(bandGameManager.currentRound) ==== This is the sets count: \(bandGameManager.selectedSets.count)")
                
                wasShook = true
                
                
                if bandGameManager.currentRound == bandGameManager.selectedSets.count {
                    isFinished = true
                }
                
                // if the answers are correct then execute the following
                if bandGameManager.checkAnswers(userEvents: currentSet) {
                    bandGameManager.incrementScore()
                
                    print("correct")
                    isTimerOn = false
                    extraInfoLabel.text = "Click events for more info"

                    
                    if isFinished {
                        finishGameButton.isHidden = false
                        finishGameButton.setImage(correctImage, for: .normal)
                        
                    } else {
                        //TODO: set the label to say correct
                        
                        nextRoundButton.isHidden = false
                        nextRoundButton.setImage(correctImage, for: .normal)
                    }

                    // If its not then excute this
                } else {
                    isTimerOn = false
                    extraInfoLabel.text = "Click events for more info"
                    
                    
                    if isFinished {
                        finishGameButton.isHidden = false
                        finishGameButton.setImage(incorrectImage, for: .normal)
                        
                    } else {
                        //TODO: set the label to say correct
                        
                        nextRoundButton.isHidden = false
                        nextRoundButton.setImage(incorrectImage, for: .normal)
                    }
                }
            }
        }
    }
    
    @IBAction func nextRoundPressed(_ sender: Any) {
        wasShook = false
        nextRound()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var DestViewController: ScoreController = segue.destination as! ScoreController
        //FIXME: this is gonna break
        
        DestViewController.labelText = "\(bandGameManager.score) / \(bandGameManager.sets.count)"
    }
    
    @IBAction func finishGamePressed(_ sender: Any) {
        print("NICE ITS DONE")
        
        self.performSegue(withIdentifier: "showScore", sender: nil)
        
//        resetGame()
//        scoreField.text = "\(bandGameManager.score) / \(bandGameManager.sets.count)"
        
    }
    
    @IBAction func dismissScore(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //------------------------------------------------
    // MARK: MISC OTHER FUNCTIONS
    //------------------------------------------------
    enum ButtonStates {
        case enabled
        case disabled
    }
    
    
    func changeButtonState(to state: ButtonStates) {
        switch state {
        case .enabled:
            Label1Button.isEnabled = true
            Label2ButtonUp.isEnabled = true
            Label2ButtonDown.isEnabled = true
            Label3ButtonUp.isEnabled = true
            Label3ButtonDown.isEnabled = true
            Label4Button.isEnabled = true
            
        case .disabled:
            Label1Button.isEnabled = false
            Label2ButtonUp.isEnabled = false
            Label2ButtonDown.isEnabled = false
            Label3ButtonUp.isEnabled = false
            Label3ButtonDown.isEnabled = false
            Label4Button.isEnabled = false
        }
    }
}

