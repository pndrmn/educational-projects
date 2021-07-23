//
//  ViewController.swift
//  My first app (day23)
//
//  Created by Roman Gorodilov on 30.04.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country flags"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("Estonia") || item.hasPrefix("France") || item.hasPrefix("Germany") || item.hasPrefix("Ireland") || item.hasPrefix("Italy") || item.hasPrefix("Monaco") || item.hasPrefix("Nigeria") || item.hasPrefix("Poland") || item.hasPrefix("Russia") || item.hasPrefix("Spain") || item.hasPrefix("UK") || item.hasPrefix("US"){
                pictures.append(item)
            }
        }
        pictures.sort()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        let name = pictures[indexPath.row]
        let finalName = String(name.dropLast(4))
        
        cell.textLabel?.text = finalName
        cell.imageView?.image = UIImage(named: pictures[indexPath.row])
        cell.imageView?.layer.borderWidth = 0.4
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            let name = pictures[indexPath.row]
            let finalName = String(name.dropLast(4))
            vc.selectedImage = finalName

            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

