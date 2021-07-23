//
//  ViewController.swift
//  Photo notes
//
//  Created by Roman Gorodilov on 27.05.2021.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var photoNotes = [PhotoNote]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPhotoNote))
        
        let defaults = UserDefaults.standard

        if let savedPeople = defaults.object(forKey: "photoNotes") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                photoNotes = try jsonDecoder.decode([PhotoNote].self, from: savedPeople)
            } catch {
                print("Failed to load photoNotes")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return photoNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)

        let photoNote = photoNotes[indexPath.row]
        let path = getDocumentsDirectory().appendingPathComponent(photoNote.photo)
        
        cell.textLabel?.text = photoNote.note
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        cell.imageView?.layer.borderWidth = 0.4
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            // 2: success! Set its selectedImage property
            let photoNote = photoNotes[indexPath.row]
            vc.selectedImage = getDocumentsDirectory().appendingPathComponent(photoNote.photo).path
            
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addNewPhotoNote() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
//        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photoNote = PhotoNote(photo: imageName, note: "")
        photoNotes.insert(photoNote, at: 0)
        tableView.reloadData()

        dismiss(animated: true)
        save()
        textNote()
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func textNote() {
        let ac = UIAlertController(title: "Add note", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in textField.placeholder = "note"}

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
            guard let note = ac?.textFields?[0].text else { return }
            self?.addNote(note: note)
        }
        
        ac.addAction(okAction)
        present(ac, animated: true)
    }
    
    func addNote(note: String) {
        let lastNote = photoNotes[0]
        lastNote.note = note
        tableView.reloadData()
        save()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let del = UIContextualAction(style: .destructive, title: nil) {[weak self] (_, _, complitionHand) in
            
            self?.photoNotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self?.save()
        }
        
        let rename = UIContextualAction(style: .normal, title: nil) { (_, _, complitionHand) in
            
            let ac = UIAlertController(title: "Change", message: nil, preferredStyle: .alert)
            ac.addTextField { (textField) in textField.placeholder = "new note"}

            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
                guard let newNote = ac?.textFields?[0].text else { return }
                self?.photoNotes[indexPath.row].note = newNote
                self?.tableView.reloadData()
                self?.save()
            }
            
            ac.addAction(okAction)
            self.present(ac, animated: true)
        }
        
        del.image = UIImage(systemName: "trash")
        rename.title = "Change"
        rename.backgroundColor = .gray
        
        return UISwipeActionsConfiguration(actions: [del, rename])
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photoNotes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photoNotes")
        } else {
            print("Failed to save photoNotes.")
        }
    }
}

