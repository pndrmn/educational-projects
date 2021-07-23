//
//  DetailViewController.swift
//  Country facts (59 day)
//
//  Created by Roman Gorodilov on 05.06.2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var fact1: UILabel!
    @IBOutlet weak var fact2: UILabel!
    @IBOutlet weak var fact3: UILabel!
    @IBOutlet weak var fact4: UILabel!
    @IBOutlet weak var fact5: UILabel!
    
    var selectedCountry: Country?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentCountry = selectedCountry else {return}
        
        title = currentCountry.name
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        fact1.text = "Capital - \(currentCountry.capital)"
        fact2.text = "Language - \(currentCountry.language)"
        fact3.text = "Area - \(currentCountry.area)"
        fact4.text = "Population - \(currentCountry.population)"
        fact5.text = "Currency - \(currentCountry.currency)"
    }
    
    @objc func shareTapped() {
        guard let currentCountry = selectedCountry else {return}
        let share = "Name - \(currentCountry.name); Capital - \(currentCountry.capital); Language - \(currentCountry.language); Area - \(currentCountry.area); Population - \(currentCountry.population); Currency - \(currentCountry.currency)"

        let vc = UIActivityViewController(activityItems: [share], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
