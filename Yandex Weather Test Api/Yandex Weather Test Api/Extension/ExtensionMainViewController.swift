//
//  extensionMainViewController.swift
//  Yandex Weather Test Api
//
//  Created by Roman Gorodilov on 08.08.2021.
//

import UIKit

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredWeatherArray.count
        }
        
        return weatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityTableViewCell

        var weather = CurrentCityWeather()
        
        if isFiltering {
            weather = filteredWeatherArray[indexPath.row]
        } else {
            weather = weatherArray[indexPath.row]
        }
        
        cell.configureCell(weather: weather)

        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
    
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        filterForSearchBar(text: text)
    }
    
    func filterForSearchBar (text: String) {
        
        filteredWeatherArray = weatherArray.filter {
            $0.city.contains(text)
        }
        reloadTableView()
    }
}
