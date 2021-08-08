//
//  MainViewController.swift
//  Yandex Weather Test Api
//
//  Created by Roman Gorodilov on 08.08.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    let network = Network()
    let emptyWeather = CurrentCityWeather()
    
    var citiesArray = Cities().arrayOfCities
    var weatherArray = [CurrentCityWeather]()
    var filteredWeatherArray = [CurrentCityWeather]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchBarIsEmpty: Bool {
        guard let searchText = searchController.searchBar.text else {
            return false
        }
        return searchText.isEmpty
    }
    
    var isFiltering: Bool {
        
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "cityCell")
        return tableView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Yandex Weather"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        
        addTableView()
        addConstraintsToSubview()
        configureSearcController()
        
        if weatherArray.isEmpty {
            weatherArray = Array(repeating: emptyWeather, count: citiesArray.count)
        }
        
        fillWeatherArray()
    }
    
    // MARK: - Table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController = DetailViewController()
        
        if isFiltering {
            detailViewController.currentWeather = filteredWeatherArray[indexPath.row]
            
            navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            
            detailViewController.currentWeather = weatherArray[indexPath.row]
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if isFiltering {
                filteredWeatherArray.remove(at: indexPath.row)
            } else {
                citiesArray.remove(at: indexPath.row)
                weatherArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    //MARK: - Functions
    
    private func addTableView() {
        view.addSubview(tableView)
    }
    
    private func addConstraintsToSubview() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fillWeatherArray() {

        network.getWeatherFor(cities: citiesArray) { [weak self] index, weather in
            
            self?.weatherArray[index] = weather
            self?.weatherArray[index].city = self!.citiesArray[index]
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func addCity() {
        
        let ac = UIAlertController(title: "Add city", message: nil, preferredStyle: .alert)
        
        ac.addTextField { textField in
            textField.placeholder = "City"
        }
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self]_ in
            
            guard let cityText = ac.textFields?[0].text?.firstUppercased else {
                return
            }
            if cityText.count < 2 {
                self?.showAC()
            } else {
                self?.citiesArray.append(cityText)
                self?.weatherArray.append(self!.emptyWeather)
                self?.fillWeatherArray()
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(cancelButton)
        ac.addAction(okButton)
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func showAC() {
        let ac = UIAlertController(title: "it's empty!", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(okButton)
        self.present(ac, animated: true)
    }
    
    func configureSearcController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
