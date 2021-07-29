//
//  Storage.swift
//  Countries
//
//  Created by Roman Gorodilov on 29.07.2021.
//

import UIKit

// MARK: - Storage -
protocol CountriesStorageProtocol {
    
    func load() -> [Country]
    
    func save(countries: [Country])
}

class CountriesStorage: CountriesStorageProtocol {
    
    private var storage = UserDefaults.standard
    
    private var storageKey = "countries"
    
    func load() -> [Country] {
        
        var resultCountries = [Country]()
        
        if let savedCountries = self.storage.object(forKey: self.storageKey) as? Data {
            
            let jsonDecoder = JSONDecoder()
            
            do {
                resultCountries = try jsonDecoder.decode([Country].self, from: savedCountries)
            } catch {
                print("Failed to load countries")
            }
        }
        return resultCountries
    }
    
    func save(countries: [Country]) {
        
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(countries) {
            storage.set(savedData, forKey: storageKey)
        } else {
            print("Failed to save countries")
        }
    }
}
