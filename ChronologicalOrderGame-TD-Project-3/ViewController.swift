//
//  ViewController.swift
//  ChronologicalOrderGame-TD-Project-3
//
//  Created by Andrew Graves on 5/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try PlistConverter.dictonary(fromFile: "GameEvents", ofType: "plist")
            let inventory = try EventUnarchiver.events(fromDictionary: dictionary)
            
            print(inventory)
            
        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let testing = PlistConverter()
        print(testing)
        print("View loaded this is epic")
        
        // Display the first question
    }


}

