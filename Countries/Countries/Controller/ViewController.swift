//
//  ViewController.swift
//  Countries
//
//  Created by Roman Gorodilov on 27.07.2021.
//

import Network
import UIKit

class ViewController: UITableViewController {
    // MARK: - Properties -
    private var countries = [Country]() {
        didSet {
            if !countries.isEmpty {
                storage.save(countries: countries)
            }
        }
    }
    // instance of NWPathMonitor
    private let monitor = NWPathMonitor()
    // instance of Storage
    var storage: CountriesStorageProtocol!
    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storage = CountriesStorage()
        
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        checkConnectivity()
    }
    // MARK: - Table View Data Sourse -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = countries[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Second") as? SecondViewController {
            
            vc.selectedCountry = countries[indexPath.row]

            navigationController?.pushViewController(vc, animated: true)
        }
    }
    // MARK: - Functions -
    private func parse() {
        
        guard let url = URL(string: "https://restcountries.eu/rest/v2/") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            do {
                if error == nil {
                    self?.countries = try JSONDecoder().decode([Country].self, from: data!)
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            } catch {
                print("Error loading data")
            }
        }.resume()
    }
    
    private func loadCountries() {
        
        DispatchQueue.global().async {
            
            self.countries = self.storage.load()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func checkConnectivity() {
        
        let queue = DispatchQueue(label: "Monitor")
        
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("We're connected!")
                self?.parse()
            } else {
                print("No connection.")
                self?.loadCountries()
            }
            print(path.isExpensive)
        }
    }
}
