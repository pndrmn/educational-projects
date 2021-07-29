//
//  Country.swift
//  Countries
//
//  Created by Roman Gorodilov on 26.07.2021.
//

import UIKit
// MARK: - Country -
protocol Loopable {
    
    func allProperties() throws -> [String: Any]
}

extension Loopable {
    
    func allProperties() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)
        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            result[property] = value
        }
        return result
    }
}

struct Country: Codable, Loopable {
    
    var name: String
    var alpha3Code: String
    var capital: String
    var region: String
    var subregion: String
    var population: Int
    var nativeName: String
    var flag: String
}



