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
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var objectName: UILabel!
    
    // Buttons
    @IBOutlet weak var Label1Button: UIButton!
    @IBOutlet weak var Label2ButtonUp: UIButton!
    @IBOutlet weak var Label2ButtonDown: UIButton!
    @IBOutlet weak var Label3ButtonUp: UIButton!
    @IBOutlet weak var Label3ButtonDown: UIButton!
    @IBOutlet weak var Label4Button: UIButton!
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var finishGameButton: UIButton!
    
    
    
    let bandGameManager = BandGameManager()
    var gameSets = [Problem]()
    var currentProblemSet = [Event]()
    var isTimerOn = false
    let correctImage = UIImage(named: "next_round_success")
    let incorrectImage = UIImage(named: "next_round_fail")
    let fullPressedDownButton = UIImage(named: "up_full_selected")
    let fullPressedUpButton = UIImage(named: "down_full_selected")
    let halfPressedUpButton = UIImage(named: "up_half_selected")
    let halfPressedDownButton = UIImage(named: "down_half_selected")
    
    var isFinished = false
    var finalScore = ""
    var wasShook = false
    var urlClicked = false
    var labelPosition = Int()

    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictonary(fromFile: "GameEvents", ofType: "plist")
            
            let eventsCollection = try EventUnarchiver.events(fromDictionary: dictionary)

            
            // Fills the sets with the data in the spreadsheet
            bandGameManager.sets = eventsCollection
            bandGameManager.generateQuestions(count: bandGameManager.sets.count, upperBound: bandGameManager.sets.count)
            
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
    
    
    // This just allows for the motion sensor to work
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    // This just rounds all the corners
    func setUpLabels() {
        let tapGesture1 = UITapGestureRecognizer.init(target: self, action: #selector(label1Clicked))
        let tapGesture2 = UITapGestureRecognizer.init(target: self, action: #selector(label2Clicked))
        let tapGesture3 = UITapGestureRecognizer.init(target: self, action: #selector(label3Clicked))
        let tapGesture4 = UITapGestureRecognizer.init(target: self, action: #selector(label4Clicked))

        tapGesture1.numberOfTapsRequired = 1
        tapGesture2.numberOfTapsRequired = 1
        tapGesture3.numberOfTapsRequired = 1
        tapGesture4.numberOfTapsRequired = 1
        
        // Label 1 Setup
        Label1.layer.cornerRadius = 10
        Label1.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        Label1.clipsToBounds = true
        Label1.isUserInteractionEnabled = false
        Label1.addGestureRecognizer(tapGesture1)
        
        // Label 2 Setup
        Label2.layer.cornerRadius = 10
        Label2.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        Label2.clipsToBounds = true
        Label2.isUserInteractionEnabled = false
        Label2.addGestureRecognizer(tapGesture2)
        
        // Label 3 Setup
        Label3.layer.cornerRadius = 10
        Label3.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        Label3.clipsToBounds = true
        Label3.isUserInteractionEnabled = false
        Label3.addGestureRecognizer(tapGesture3)
        
        // Label 4 Setup
        Label4.layer.cornerRadius = 10
        Label4.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        Label4.clipsToBounds = true
        Label4.isUserInteractionEnabled = false
        Label4.addGestureRecognizer(tapGesture4)
        
        // Label 1 Button Setup
        Label1Button.layer.cornerRadius = 10
        Label1Button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        Label1Button.clipsToBounds = true
        Label1Button.setImage(fullPressedUpButton, for: .highlighted)
        
        // Label 2 Button Setup
        Label2ButtonUp.layer.cornerRadius = 10
        Label2ButtonUp.layer.maskedCorners = [.layerMaxXMinYCorner]
        Label2ButtonUp.clipsToBounds = true
        Label2ButtonUp.setImage(halfPressedUpButton, for: .highlighted)
        Label2ButtonDown.layer.cornerRadius = 10
        Label2ButtonDown.layer.maskedCorners = [.layerMaxXMaxYCorner]
        Label2ButtonDown.clipsToBounds = true
        Label2ButtonDown.setImage(halfPressedDownButton, for: .highlighted)
        
        // Label 3 Button Setup
        Label3ButtonUp.layer.cornerRadius = 10
        Label3ButtonUp.layer.maskedCorners = [.layerMaxXMinYCorner]
        Label3ButtonUp.clipsToBounds = true
        Label3ButtonUp.setImage(halfPressedUpButton, for: .highlighted)
        Label3ButtonDown.layer.cornerRadius = 10
        Label3ButtonDown.layer.maskedCorners = [.layerMaxXMaxYCorner]
        Label3ButtonDown.clipsToBounds = true
        Label3ButtonDown.setImage(halfPressedDownButton, for: .highlighted)

        // Label 4 Button Setup
        Label4Button.layer.cornerRadius = 10
        Label4Button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        Label4Button.clipsToBounds = true
        Label4Button.setImage(fullPressedDownButton, for: .highlighted)

        // Sets up the button at the end of the game
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
        timerLabel.text = "60"
        
        // Takes the data and passes it into the labels for display
        Label1.text = currentProblemSet[0].title
        Label2.text = currentProblemSet[1].title
        Label3.text = currentProblemSet[2].title
        Label4.text = currentProblemSet[3].title
        
        // Displays the band name above the labels
        objectName.text = gameSets[currentRound - 1].bandName
        
        // hides the next round button
        nextRoundButton.isHidden = true

        // Start the timer
        print("timer started")
        
        // Sets the timer to on, enables the buttons and starts the round timer
        isTimerOn = true
        self.changeButtonState(to: .enabled)
        roundTimer(currentRound: currentRound, withTimerOf: 60)
    }
    
    // Handles the next round logic
    func nextRound() {
        // adds one to the round count
        bandGameManager.incrementRound()

        // calls the display problem func
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
                    
                    // if the current round is == to the round when the timer was started
                    if currentRound == self.bandGameManager.currentRound {
                        
                        //TODO: Disable the buttons
                        self.changeButtonState(to: .disabled)
                        self.nextRoundButton.isHidden = false

                        // Set the button to the incorrect image
                        self.nextRoundButton.setImage(self.incorrectImage, for: .normal)
                        
                        // Changes the label at the bottom
                        self.extraInfoLabel.text = "Click events for more info"
                        
                    } else {
                        // Do nothing, the timer does not apply to this round
                    }
                    
                // If the counter is not 0
                } else {
                    
                    // if the current round is == to the round when the timer was started
                    if currentRound == self.bandGameManager.currentRound {
                        
                        // subtract 1 from the counter
                        counter -= 1
                        
                        // Update the timer label to reflect this new value
                        self.timerLabel.text = "\(counter)"
                        
                        // Calls this function again with a timer value that is one less then it used to be
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
        // Switches on the direction provided, either up or down
        switch direction {
            
        // if its .up
        case .up:
            switch position {
            case 0: return
            case 1:
                // move what was on the top one below visually
                let topText = Label1.text
                Label1.text = Label2.text
                Label2.text = topText
                
                // Also updates the data
                updateCurrentEventsUp(topEvent: 0)
            case 2: return
            case 3:
                let topText = Label2.text
                Label2.text = Label3.text
                Label3.text = topText
                
                updateCurrentEventsUp(topEvent: 1)

            case 4: return
            case 5:
                let topText = Label3.text
                Label3.text = Label4.text
                Label4.text = topText
                
                updateCurrentEventsUp(topEvent: 2)

            default: return
            }
            
        // If its .down
        case .down:
            switch position {
            case 0:
                let bottomText = Label2.text
                Label2.text = Label1.text
                Label1.text = bottomText
                
                updateCurrentEventsDown(bottomEvent: 1)
            case 1: return
            case 2:
                let bottomText = Label3.text
                Label3.text = Label2.text
                Label2.text = bottomText
                
                updateCurrentEventsDown(bottomEvent: 2)
            case 3: return
            case 4:
                let bottomText = Label4.text
                Label4.text = Label3.text
                Label3.text = bottomText
                
                updateCurrentEventsDown(bottomEvent: 3)
            case 5: return
            default: return
            }
        }
    }
    
    // Called when an item it is moving up
    func updateCurrentEventsUp(topEvent: Int) {
        let firstEvent = currentProblemSet[topEvent]
        currentProblemSet[topEvent] = currentProblemSet[topEvent + 1]
        currentProblemSet[topEvent + 1] = firstEvent
    }
    
    // Called when an item it is moving down
    func updateCurrentEventsDown(bottomEvent: Int) {
        let lastEvent = currentProblemSet[bottomEvent]
        currentProblemSet[bottomEvent] = currentProblemSet[bottomEvent - 1]
        currentProblemSet[bottomEvent - 1] = lastEvent
    }
    
    // reset game functionality
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
    
    // Functionality for the arrow buttons being clicked
    @IBAction func buttonsClicked(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        // Depending on the tag of the button, it has a different position and direction
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
            Label1.isUserInteractionEnabled = true
            Label2.isUserInteractionEnabled = true
            Label3.isUserInteractionEnabled = true
            Label4.isUserInteractionEnabled = true
            
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
    
    // When the label text is clicked carry out the following functions
    @objc func label1Clicked() {
        print("Label1 was clicked \(currentProblemSet[0].title)")
        urlClicked = true
        labelPosition = 0
        
        performSegue(withIdentifier: "showWebView", sender: nil)
    }
    
    @objc func label2Clicked() {
        print("Label2 was clicked \(currentProblemSet[1].title)")
        urlClicked = true
        labelPosition = 1
        
        performSegue(withIdentifier: "showWebView", sender: nil)
    }
    
    @objc func label3Clicked() {
        print("Label3 was clicked \(currentProblemSet[2].title)")
        urlClicked = true
        labelPosition = 2
        
        performSegue(withIdentifier: "showWebView", sender: nil)
    }
    
    @objc func label4Clicked() {
        print("Label4 was clicked \(currentProblemSet[3].title)")
        urlClicked = true
        labelPosition = 3
        
        performSegue(withIdentifier: "showWebView", sender: nil)
    }
    
    
    
    // When the next round pressed button is pressed...
    @IBAction func nextRoundPressed(_ sender: Any) {
        wasShook = false
        nextRound()
    }
    
    
    // some logic for determining which view to switch to
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if urlClicked {
            let DestViewController: WebViewController = segue.destination as! WebViewController
            DestViewController.url = currentProblemSet[labelPosition].url
            
            urlClicked = false
        } else {
            let DestViewController: ScoreController = segue.destination as! ScoreController
            DestViewController.labelText = "\(bandGameManager.score) / \(bandGameManager.sets.count)"
            
        }
    }
    
    
    // When the finished game button is pressed
    @IBAction func finishGamePressed(_ sender: Any) {
        
        performSegue(withIdentifier: "showScore", sender: nil)
        
    }
    
    //------------------------------------------------
    // MARK: MISC OTHER FUNCTIONS
    //------------------------------------------------
    
    // an enum for the two different button states
    enum ButtonStates {
        case enabled
        case disabled
    }
    
    // A function to deal with changes in button states from enabled to disabled
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

