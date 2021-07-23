//
//  DetailViewController.swift
//  Notes (day 74)
//
//  Created by Roman Gorodilov on 21.06.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var detailNotes = [Note]()
    var selectedNote: Note!
    var detailNewNote: Note!
    var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addNote))
        if selectedNote != nil {
            textView.text = selectedNote.note
        }
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let send = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sendNote))

        toolbarItems = [spacer, send]
        navigationController?.isToolbarHidden = false
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func addNote() {
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: "Main") as? ViewController {
            
            if selectedNote == nil {

                detailNewNote = Note(note: textView.text)
                detailNotes.insert(detailNewNote, at: 0)
                print("add")

            } else {
                
                selectedNote.note = textView.text
                detailNotes.remove(at: index)
                detailNotes.insert(selectedNote, at: index)
                print("change")
                
            }
            
            mainVC.notes = detailNotes
            mainVC.save()
//            mainVC.tableView.reloadData()
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func sendNote() {
        guard let currentNote = textView.text else {return}
        let share = currentNote

        let vc = UIActivityViewController(activityItems: [share], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}
