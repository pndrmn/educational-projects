//
//  DetailViewController.swift
//  Yandex Weather Test Api
//
//  Created by Roman Gorodilov on 08.08.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var currentWeather: CurrentCityWeather!
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = currentWeather.city
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(currentWeather.temp)℃"
        label.font = UIFont.systemFont(ofSize: 70)
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(currentWeather.conditionEmoji)"
        label.font = UIFont.systemFont(ofSize: 200)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Minimum temperature: \(currentWeather.tempMin)℃"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Maximum temperature: \(currentWeather.tempMax)℃"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wind: \(currentWeather.windDir.uppercased()) \(currentWeather.windSpeed) m/s"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var pressureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Atm. pressure: \(currentWeather.pressureMm) mm"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Yandex Weather"
        view.backgroundColor = .white
        
        addSubviews()
        addConstraintsToSubviews()
    }
    
    //MARK: - Functions
    private func addSubviews() {
        [cityLabel, conditionLabel, tempLabel, minTempLabel, maxTempLabel, windLabel, pressureLabel].forEach {view.addSubview($0)}
    }
    
    private func addConstraintsToSubviews() {
        
        NSLayoutConstraint.activate([
            
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            cityLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            conditionLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor),
            conditionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            conditionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            conditionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            conditionLabel.heightAnchor.constraint(equalTo: conditionLabel.widthAnchor, multiplier: 2/3),
            
            tempLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor),
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            minTempLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 100),
            minTempLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            maxTempLabel.topAnchor.constraint(equalTo: minTempLabel.bottomAnchor, constant: 15),
            maxTempLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            windLabel.topAnchor.constraint(equalTo: maxTempLabel.bottomAnchor, constant: 15),
            windLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            pressureLabel.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 15),
            pressureLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
        ])
    }
}
