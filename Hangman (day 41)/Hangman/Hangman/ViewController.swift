//
//  ViewController.swift
//  Hangman
//
//  Created by Roman Gorodilov on 18.05.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var livesLabel: UILabel!
    var wordLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var lives = 7 {
        didSet {
            livesLabel.text = "\u{2764}\(lives)"
        }
    }
    
    var currentWord = ""
    var cryptWord = ""
    var usedLetters = "" {
        didSet {
            cryptWord = ""
            for letter in currentWord {
                
                let strLetter = String(letter)
                
                if usedLetters.contains(strLetter) {
                    cryptWord += strLetter
                } else {
                    cryptWord += "?"
                }
                wordLabel.text = cryptWord
            }
        }
    }
    
    var letterBits = [String]()
    
    let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        livesLabel = UILabel()
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.textAlignment = .right
        livesLabel.font = UIFont.systemFont(ofSize: 80)
        livesLabel.text = "\u{2764}\(lives)"
        view.addSubview(livesLabel)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 50)
        wordLabel.text = ""
        wordLabel.numberOfLines = 0
        view.addSubview(wordLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            livesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            livesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            wordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 200),
            wordLabel.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -20),
        
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 430),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            buttonsView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        // set some values for the width and height of each button
        let width = 107
        let height = 107
//             create 20 buttons as a 4x5 gri
        for row in 0..<4 {
            for col in 0..<7 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
                
                // give the button some temporary text so we can see it on-screen
                letterButton.setTitle("0", for: .normal)
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                
                // and also to our letterButtons array
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                if letterButtons.count == 26 {
                    break
                }
            }
        }
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadLevel), with: nil)
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }

        if currentWord.contains(buttonTitle) {
            usedLetters += String(buttonTitle)
            
            if currentWord == wordLabel.text {
                let ac = UIAlertController(title: "You win!", message: "Start new game", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default, handler: newGame))
                present(ac, animated: true)
            }
            
            activatedButtons.append(sender)
            sender.isHidden = true
            
        } else {
            lives -= 1
            if lives == 0 {
                let ac = UIAlertController(title: "Game over", message: "Try again!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "ok", style: .default, handler: newGame))
                present(ac, animated: true)
            }
        }
    }
    
    @objc func loadLevel() {

        if let wordsFileURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let wordsContents = try? String(contentsOf: wordsFileURL) {
                let lines = wordsContents.components(separatedBy: "\n")
                if let randomWord = lines.randomElement() {
                    currentWord = randomWord
                }

                for bit in alphabet {

                    let bits = [String(bit)]
                    letterBits += bits
                }
            }
        }
        performSelector(onMainThread: #selector(updateUI), with: nil, waitUntilDone: false)
    }

    @objc func updateUI() {
        for var char in currentWord {
            char = "?"
            cryptWord += String(char)
        }
        
        wordLabel.text = cryptWord

        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        print(currentWord)
    }
    
    func newGame(action: UIAlertAction) {
        currentWord = ""
        activatedButtons.removeAll()
        lives = 7
        usedLetters.removeAll()
        
        performSelector(inBackground: #selector(loadLevel), with: nil)

        for btn in letterButtons {
            btn.isHidden = false
        }
    }
}

