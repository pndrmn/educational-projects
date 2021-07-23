//
//  ViewController.swift
//  Meme Generator
//
//  Created by Roman Gorodilov on 08.07.2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var currentImage: UIImage!
    var topString: String?
    var bottomString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        let buttonShare = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItems = [buttonAdd, buttonShare]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)
        
        currentImage = image
        imageView.image = currentImage
        
        let ac = UIAlertController(title: "Text at the top", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in textField.placeholder = "write something or not"}
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
            guard let topText = ac?.textFields?[0].text else { return }
            self!.topString = topText
            let ac2 = UIAlertController(title: "Text at the bottom", message: nil, preferredStyle: .alert)
            ac2.addTextField { (textField) in textField.placeholder = "write something or not"}
            let okAction2 = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac2] action in
                guard let bottomText = ac2?.textFields?[0].text else { return }
                self!.bottomString = bottomText
                self?.makeMeme()
            }
            ac2.addAction(okAction2)
            self!.present(ac2, animated: true)
        }
        ac.addAction(okAction)
        self.present(ac, animated: true)
    }
    
    @objc func save(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            let ac = UIAlertController(title: "No image for save", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func share() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func makeMeme() {
        
        if let imageToLoad = currentImage {
            
            let heightImage = imageToLoad.size.height
            let widthImage = imageToLoad.size.width
            
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: widthImage, height: heightImage))
            
            let img = renderer.image { ctx in
                
                let memeImage = imageToLoad
                memeImage.draw(at: CGPoint(x: 0, y: 0))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .strokeColor: UIColor.black,
                    .strokeWidth: -2.5,
                    .font: UIFont(name: "Helvetica", size: 70)!,
                    .foregroundColor: UIColor.white,
                    .paragraphStyle: paragraphStyle
                ]
                
                guard let stringTop = topString else {return}
                let attributedStringTop = NSAttributedString(string: stringTop, attributes: attrs)
                
                guard let stringBottom = bottomString else {return}
                let attributedStringBottom = NSAttributedString(string: stringBottom, attributes: attrs)
                
                attributedStringTop.draw(with: CGRect(x: 0, y: 20, width: widthImage, height: heightImage), options: .usesLineFragmentOrigin, context: nil)
                attributedStringBottom.draw(with: CGRect(x: 0, y: memeImage.size.height - 150, width: widthImage, height: heightImage), options: .usesLineFragmentOrigin, context: nil)
            }
            
            imageView.image = img
        }
    }
}

