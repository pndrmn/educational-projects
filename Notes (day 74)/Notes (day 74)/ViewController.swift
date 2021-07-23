//
//  ViewController.swift
//  Notes (day 74)
//
//  Created by Roman Gorodilov on 21.06.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    var notes = [Note]() {
        didSet {
            if notes.count != 1 {
                countNotes.title = "\(notes.count) notes"
            } else {
                countNotes.title = "\(notes.count) note"
            }
        }
    }
    var newNote: Note!
    var countNotes = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        countNotes = UIBarButtonItem(title: "\(notes.count) notes", style: .plain, target: nil, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(openDetailVC))

        toolbarItems = [countNotes,spacer, add]
        navigationController?.isToolbarHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("mainWillAppear")
        load()
        DispatchQueue.main.async { self.tableView.reloadData() }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        
        cell.textLabel?.text = notes[indexPath.row].note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            vc.detailNotes = notes
            vc.selectedNote = notes[indexPath.row]
            vc.index = indexPath.row
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        }
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func save() {
        print("save")
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save notes")
        }
    }
    
    func load() {
        print("load")
        
        notes.removeAll()
        
        let defaults = UserDefaults.standard

        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load notes")
            }
        }
    }
    
    @objc func openDetailVC() {

        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            vc.detailNotes = notes
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

