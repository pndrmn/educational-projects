//
//  ViewController.swift
//  Country facts (59 day)
//
//  Created by Roman Gorodilov on 05.06.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var countrys = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country facts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        guard let url = Bundle.main.url(forResource: "JSON countrys", withExtension: "json") else {return}
//        guard let data = try? Data(contentsOf: url) else {return}
//
//        parse(json: data)
        performSelector(inBackground: #selector(loadingData), with: nil)
    }
    
    @objc func loadingData() {
        guard let url = Bundle.main.url(forResource: "JSON countrys", withExtension: "json") else {return}
        guard let data = try? Data(contentsOf: url) else {return}
        
        parse(json: data)
        performSelector(onMainThread: #selector(updateTableView), with: nil, waitUntilDone: false)
    }
    
    @objc func updateTableView() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countrys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = countrys[indexPath.row].name
        return cell
    }

    func parse(json: Data) {
        
        let decoder = JSONDecoder()

        do {
            let countrysFromJSON = try decoder.decode([Country].self, from: json)
            countrys = countrysFromJSON
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            vc.selectedCountry = countrys[indexPath.row]

            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

