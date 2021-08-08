//
//  Network.swift
//  Yandex Weather Test Api
//
//  Created by Roman Gorodilov on 08.08.2021.
//

import CoreLocation
import Foundation

struct Network {
    
    func getDataWeather(lat: Double, lon: Double, completionHandler: @escaping (CurrentCityWeather) -> Void) {
        
        let urlString = "https://api.weather.yandex.ru/v2/forecast?lat=\(lat)&lon=\(lon)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("\(keyAPI)", forHTTPHeaderField: "X-Yandex-API-Key")
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let dataWeather = data else {
                print(String(describing: error))
                return
            }
            
            if let currentWeather = parse(data: dataWeather) {
                completionHandler(currentWeather)
            }
        }
        session.resume()
    }
    
    func parse(data: Data) -> CurrentCityWeather? {
        
        let decoder = JSONDecoder()
        
        do {
            let dataWeather = try decoder.decode(Weather.self, from: data)
            guard let weather = CurrentCityWeather(weather: dataWeather) else {
                return nil
            }
            return weather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func getCoordinatesOf(city: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> Void) {
        
        CLGeocoder().geocodeAddressString(city) { (placemark, error) in
            
            completion(placemark?.first?.location?.coordinate, error)
        }
    }
    
    func getWeatherFor(cities: [String], completionHandler: @escaping (Int, CurrentCityWeather) -> Void) {
        
        for (index, city) in cities.enumerated() {
            
            getCoordinatesOf(city: city) { coordinate, error in
                
                guard let coordinate = coordinate, error == nil else {return}
                
                getDataWeather(lat: coordinate.latitude, lon: coordinate.longitude) { (weather) in
                    completionHandler(index, weather)
                }
            }
        }
    }
}
