//
//  ViewController.swift
//  Extension (day 82)
//
//  Created by Roman Gorodilov on 30.06.2021.
//




import UIKit
//MARK: 1
extension UIView {
    func bounceOut(duration: TimeInterval) {
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
    
    func bounceIn(duration: TimeInterval) {
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.transform = .identity
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func bounceOut(_ sender: UIButton) {
        label.bounceOut(duration: 2)
    }
    
    @IBAction func bounceIn(_ sender: Any) {
        label.bounceIn(duration: 2)
    }
}


