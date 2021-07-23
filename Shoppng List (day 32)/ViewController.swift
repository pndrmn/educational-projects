//
//  ViewController.swift
//  Shoppng List (day 32)
//
//  Created by Roman Gorodilov on 09.05.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let sharer = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        toolbarItems = [spacer, sharer]
        navigationController?.isToolbarHidden = false
        
        title = "Shopping List"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thing", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Add to list", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let addAction = UIAlertAction(title: "Done!", style: .default) { [weak self, weak ac] action in
            guard let thing = ac?.textFields?[0].text else { return }
            self?.add(thing)
        }

        ac.addAction(addAction)
        present(ac, animated: true)
    }
    
    @objc func shareTapped() {
        let list = shoppingList.joined(separator: "\n")

        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func add(_ thing: String) {
        shoppingList.insert(thing, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func reset(){
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
}

