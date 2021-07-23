//
//  ViewController.swift
//  Concentration Game (day 99)
//
//  Created by Roman Gorodilov on 17.07.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let emojiArray = ["❓", "❓", "🎁", "🎁", "🐼", "🐼", "🌹", "🌹", "🍄", "🍄", "🚗", "🚗", "🍉", "🍉", "🙂", "🙂"]
    
    var buttonsView: UIView!
    var attemptsLabel: UILabel!
    var cardsButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var counterForWin = 0
    var attempts = 0 {
        didSet {
            attemptsLabel.text = "Attempts: \(attempts)"
        }
    }
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
        attemptsLabel = UILabel()
        attemptsLabel.translatesAutoresizingMaskIntoConstraints = false
        attemptsLabel.textAlignment = .center
        attemptsLabel.text = "Attempts: 0"
        view.addSubview(attemptsLabel)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            attemptsLabel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -75),
            attemptsLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -22),
            buttonsView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, constant: -250),
            buttonsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
            
        ])
        getCards()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Concentration"
    }

    @objc func cardTapped(_ sender: UIButton) {
//        if !activatedButtons.isEmpty {
//            if sender == activatedButtons[0] {
//                return
//            }
//        }
        if activatedButtons.contains(sender) {
            return
        }
        
        activatedButtons.append(sender)
        guard let buttonTitle = sender.titleLabel?.text else { return }
        if activatedButtons.count < 3 {
            attempts += 1
            sender.setBackgroundImage(nil, for: .normal)
            sender.titleLabel?.layer.opacity = 1
            compareCards()
        }
    }
    
    func compareCards() {
        if activatedButtons.count == 2 {
            if activatedButtons[0].titleLabel?.text == activatedButtons[1].titleLabel?.text {
                for activatedButton in activatedButtons {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        activatedButton.isHidden = true
                    })
                }
                counterForWin += 1
            } else {
                for activatedButton in activatedButtons {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        activatedButton.titleLabel?.layer.opacity = 0
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        let btnImage = UIImage(named: "texture.jpg")
                        activatedButton.setBackgroundImage(btnImage, for: .normal)
                    })
                }
            }
            activatedButtons.removeAll()
        }
        if counterForWin == 8 {
            showWinAlert()
        }
    }
    
    func showWinAlert() {
        let ac = UIAlertController(title: "You Win!", message: "Are you ready to start a New Game?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: startNewGame))
        present(ac, animated: true)
    }
    
    func startNewGame(action: UIAlertAction) {
        attempts = 0
        counterForWin = 0
        cardsButtons.removeAll()
        getCards()
    }
    
    func getCards() {
        var arrayForRound = emojiArray.shuffled()
        // create 16 cardButtons as a 4x4 grid
        for _ in 0..<arrayForRound.count {
            
            let emojiForButton = arrayForRound[0]
            arrayForRound.remove(at: 0)
            //create a new button and give it a big font size
            let cardButton = UIButton(type: .system)
            cardButton.translatesAutoresizingMaskIntoConstraints = false
            cardButton.titleLabel?.font = UIFont.systemFont(ofSize: 44)
            
            // give the button some temporary text so we can see it on-screen
            cardButton.setTitle(emojiForButton, for: .normal)
            // give the button image
            let btnImage = UIImage(named: "texture.jpg")
            cardButton.setBackgroundImage(btnImage, for: .normal)
            
            // add it to the buttons view
            buttonsView.addSubview(cardButton)
            if cardsButtons.count == 0 {
                NSLayoutConstraint.activate([
                    cardButton.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.25),
                    cardButton.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 0.25),
                    cardButton.leftAnchor.constraint(equalTo: buttonsView.leftAnchor),
                    cardButton.topAnchor.constraint(equalTo: buttonsView.topAnchor)
                ])
            } else if cardsButtons.count % 4 == 0 {
                NSLayoutConstraint.activate([
                    cardButton.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.25),
                    cardButton.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 0.25),
                    cardButton.leftAnchor.constraint(equalTo: buttonsView.leftAnchor),
                    cardButton.topAnchor.constraint(equalTo: cardsButtons[cardsButtons.count - 1].bottomAnchor)
                ])
            } else  {
                NSLayoutConstraint.activate([
                    cardButton.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.25),
                    cardButton.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 0.25),
                    cardButton.leftAnchor.constraint(equalTo: cardsButtons[cardsButtons.count - 1].rightAnchor),
                    cardButton.topAnchor.constraint(equalTo: cardsButtons[cardsButtons.count - 1].topAnchor)
                ])
            }
            // and also to our letterButtons array
            cardsButtons.append(cardButton)
            cardButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
            
            cardButton.layer.borderWidth = 1
            cardButton.layer.borderColor = UIColor.black.cgColor
        }
        for button in cardsButtons {
            button.titleLabel?.layer.opacity = 0
        }
    }
}

