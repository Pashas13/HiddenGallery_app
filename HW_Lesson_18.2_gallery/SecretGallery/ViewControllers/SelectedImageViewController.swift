//
//  SelectedImageViewController.swift
//  HW Lesson 18.2 (хранилка картинок)
//
//  Created by Pasha on 09.12.2020.
//
// swiftlint:disable all

import UIKit

class SelectedImageViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var selectedImageView: UIImageView!

    // MARK: - Public properties
    
    var selectedImage = UIImage()

    // MARK: - Lifestyle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        selectedImageView.image = selectedImage
    }
    
    // MARK: - IBActions

    @IBAction func deleteButtonTapped(_ sender: Any) {

        if let imagePath = UserDefaults.standard.value(forKey: "imagePathKey") as? String {
            
            let deleteAlert = UIAlertController(title: "Delete photo", message: "Are you sure? Do you want to delete this photo?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "DELETE", style: .destructive) { (_) in
                self.navigationController?.popViewController(animated: true)
                if FileManager.default.fileExists(atPath: imagePath) {
                    do {
                        try FileManager.default.removeItem(atPath: imagePath)
                    } catch {
                        print(error)
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            
            deleteAlert.addAction(deleteAction)
            deleteAlert.addAction(cancelAction)
            present(deleteAlert, animated: true, completion: nil)
            }
        }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        if let imagePath = UserDefaults.standard.value(forKey: "imagePathKey") as? String {
            if let image = UIImage(contentsOfFile: imagePath) {
                let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                present(shareController, animated: true, completion: nil)
            }
        }
    }
    
}
