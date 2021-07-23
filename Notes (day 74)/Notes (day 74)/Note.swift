//
//  Note.swift
//  Notes (day 74)
//
//  Created by Roman Gorodilov on 21.06.2021.
//

import UIKit

class Note: NSObject, Codable {

    var note: String
    
    init(note: String) {
        
        self.note = note
    }
}
