//
//  ChronologicalOrderItems.swift
//  ChronologicalOrderGame-TD-Project-3
//
//  Created by Andrew Graves on 5/21/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import Foundation

enum BandNames: String {
    case coldplay
    case muse
    case radiohead
}

//protocol EventItem {
//    var name: BandNames { get }
//    var information : [InfoItem] { get }
//}
//
//protocol InfoItem {
//    var title: String { get }
//    var position: Int { get }
//    var link: String { get }
//}
//
//
//
//
//struct BandInfoItem: InfoItem {
//    var title: String
//    var position: Int
//    var link: String
//
//}
//
//struct BandItem: EventItem {
//    var name: BandNames
//    var information: [InfoItem]
//
//}



protocol Problem {
    var events: [Event] { get }
    var bandName: String { get }
}

protocol Event {
    var title: String { get }
    var position: Int { get }
    var url: String { get }
}

enum MovementDirections {
    case up
    case down
}






struct BandProblem: Problem {
    var events: [Event]
    var bandName: String
    
}

struct BandEvent: Event {
    var title: String
    var position: Int
    var url: String
    
}
