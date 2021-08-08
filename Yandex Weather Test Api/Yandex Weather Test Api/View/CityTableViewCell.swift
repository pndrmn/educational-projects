//
//  CityTableViewCell.swift
//  Yandex Weather Test Api
//
//  Created by Roman Gorodilov on 08.08.2021.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    let cityLabel = UILabel()
    let weatherLabel = UILabel()
    let temperatureLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.textAlignment = .left
        weatherLabel.textAlignment = .right
        temperatureLabel.textAlignment = .right
        
        self.contentView.addSubview(cityLabel)
        self.contentView.addSubview(weatherLabel)
        self.contentView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant:10),
            cityLabel.widthAnchor.constraint(equalToConstant: 250),
            cityLabel.heightAnchor.constraint(equalToConstant: 40),
            
            weatherLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            weatherLabel.leadingAnchor.constraint(equalTo: self.cityLabel.trailingAnchor, constant: 10),
            weatherLabel.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -10),
            weatherLabel.heightAnchor.constraint(equalToConstant: 40),
            
            temperatureLabel.widthAnchor.constraint(equalToConstant: 60),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 40),
            temperatureLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            temperatureLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(weather: CurrentCityWeather) {
        
        cityLabel.text = weather.city
        weatherLabel.text = weather.conditionEmoji
        temperatureLabel.text = "\(String(weather.temp))℃"
    }
}
