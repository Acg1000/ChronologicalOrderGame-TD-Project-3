//
//  ChronologicalOrderItems.swift
//  ChronologicalOrderGame-TD-Project-3
//
//  Created by Andrew Graves on 5/20/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import Foundation

enum BandNames: String {
    case coldplay
    case radiohead
    case muse
}

struct BandItems {
    var name: BandNames
    var link: URL
}
