//
//  ChronologicalOrderSet.swift
//  ChronologicalOrderGame-TD-Project-3
//
//  Created by Andrew Graves on 5/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import Foundation

//protocol ChronologicalOrderSet {
//    // an array of randomised items
//    var items: [ChronologicalOrderItems] { get }
//
//    // an array of correct items
//    var correctItems: [ChronologicalOrderItems] { get }
//
//    // a function that checks to see if the input matches the correct array
//    func isCorrect()
//}

struct ChronologicalOrderSet {
    var items: [BandItem]
    var correctItems: [BandItem]
    
    func isCorrect(set: [BandItem]) {
        // Check if its correct
    }
}
