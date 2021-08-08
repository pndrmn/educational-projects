//
//  Weather.swift
//  Yandex Weather Test Api
//
//  Created by Roman Gorodilov on 08.08.2021.
//

import Foundation

struct Weather: Codable {
    let info: Info
    let fact: Fact
    let forecasts: [Forecast]
}


struct Info: Codable {
    let url: String
}

struct Fact: Codable {
    let temp: Int
    let condition: String
    let windSpeed: Double
    let windDir: String
    let pressureMm: Int
    let daytime: String
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case condition
        case windSpeed = "wind_speed"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case daytime
    }
}

struct Forecast: Codable {
    let parts: Parts
}

struct Parts: Codable {
    let day: Day
}

struct Day: Codable {
    let tempMin: Int?
    let tempMax: Int?
    let daytime: String
    
    private enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case daytime
    }
}
