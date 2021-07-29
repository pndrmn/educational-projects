//
//  SecondViewController.swift
//  Countries
//
//  Created by Roman Gorodilov on 28.07.2021.
//

import UIKit
import WebKit

extension SecondViewController: UITableViewDataSource {
    // MARK: - Table View Data Sourse -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell

        if let reuseCell = tableView.dequeueReusableCell(withIdentifier:"MyCell") {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
        
        configure(cell: &cell, for: indexPath)
        
        return cell
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        
        var configuration = cell.defaultContentConfiguration()
        
        configuration.text = "\(keys[indexPath.row].uppercased()): \(values[indexPath.row])"
        
        cell.contentConfiguration = configuration
    }
}

class SecondViewController: UIViewController {
    // MARK: - Properties -
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var tableView: UITableView!
    
    
    var selectedCountry: Country!
    private var dictProperties: [String: Any]!
    private var keys = [String]()
    private var values = [Any]()
    
    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = selectedCountry.name
        
        if let urlFlag = URL(string: selectedCountry.flag) {
            webView.load(URLRequest(url: urlFlag))
        }
        
        tableView.layer.borderWidth = 0.25
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        do {
            dictProperties = try selectedCountry.allProperties()
        } catch {
            print("Error")
        }
        
        for (key, value) in dictProperties {
            
            if key != "flag" {
                keys.append(key)
                values.append(value)
            }
        }
    }
}
