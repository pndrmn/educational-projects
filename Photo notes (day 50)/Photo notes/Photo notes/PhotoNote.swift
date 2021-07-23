//
//  PhotoNote.swift
//  Photo notes
//
//  Created by Roman Gorodilov on 27.05.2021.
//

import UIKit

class PhotoNote: NSObject, Codable {
    
    var photo: String
    var note: String
    
    init(photo: String, note: String) {
        self.photo = photo
        self.note = note
    }
}
