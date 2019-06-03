//
//  ScoreController.swift
//  ChronologicalOrderGame-TD-Project-3
//
//  Created by Andrew Graves on 5/31/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import UIKit

class ScoreController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    // The label text that is passed through the prepare method
    var labelText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel.text = labelText
    }
    
    // when the play again button is pressed
    @IBAction func playAgainPressed(_ sender: Any) {
        
        // call the other viewcontroller
        self.performSegue(withIdentifier: "showGame", sender: nil)
    }

}
