//
//  Tips.swift
//  MiniFlickr
//
//  Created by Daniel Priestley on 10/11/2023.
//

import Foundation
import TipKit

struct SearchBarTip: Tip {
    var title: Text {
        Text("Search for Photos")
    }
    
    var message: Text? {
        Text("Search for photos from by placing an @ in front of the username, or search multiple tags by separating them with a comma.")
    }
    
    var image: Image? {
        Image(systemName: "at.circle")
    }
}


