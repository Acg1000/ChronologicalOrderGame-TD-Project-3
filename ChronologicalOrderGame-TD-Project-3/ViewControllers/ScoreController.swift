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
    
    var labelText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel.text = labelText
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var DestViewController: ViewController = segue.destination as! ViewController
        //FIXME: this is gonna break
        
    }
    
    @IBAction func playAgainPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showGame", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
