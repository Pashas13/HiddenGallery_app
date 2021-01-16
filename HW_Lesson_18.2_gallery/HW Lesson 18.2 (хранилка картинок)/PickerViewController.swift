//
//  PickerViewController.swift
//  HW Lesson 18.2 (хранилка картинок)
//
//  Created by Pasha on 18.11.2020.
//
// swiftlint:disable all

import UIKit

class PickerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addPhotoButton: UIButton!
    private let pickerController = UIImagePickerController()

    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileManager = FileManager.default
    lazy var imagesPath = documentsPath.appendingPathComponent("Images")

    var imagesArray = [UIImage]()
    var arrayOfNamed = [String]()
    var previousSelected: IndexPath?
    var currentSelected: Int?
    var numberOfImage = Int()
    
    let userLogins = [String]()
    var userLogin = UserDefaults.standard.value(forKey: "Login") as? String


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        if let login = userLogin {
            let newPath = imagesPath.appendingPathComponent(login)
            try? fileManager.createDirectory(at: newPath, withIntermediateDirectories: true, attributes: nil)
            print(newPath)
            print("user \(login)")
           
        } else {
            print ("error")
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

        addPhotoButton.layer.cornerRadius = 20
        imageCreation()
        collectionView.reloadData()

    }
    
    
    func imageCreation() {
        imagesArray.removeAll()
        if let login = userLogin {
            if let imageNames = try? fileManager.contentsOfDirectory(atPath: "\(imagesPath.path)/\(login)") {
                for imageName in imageNames {
                    if let image = UIImage(contentsOfFile: "\(imagesPath.path)/\(login)/\(imageName)") {
                        imagesArray.append(image)
                        arrayOfNamed.append(imageName)
                    }
                }
            }
        }
    }

    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
}

extension PickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey: Any]) {

        if let image = info [.editedImage] as? UIImage {
            if fileManager.fileExists(atPath: imagesPath.path) == false {
                do {
        try fileManager.createDirectory(atPath: imagesPath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("error 2")
                }
            }
            imagesArray.append(image)
            let data = image.jpegData(compressionQuality: 1)
            let imageName = "\(Date().timeIntervalSince1970).png"
            arrayOfNamed.append(imageName)
            
            if userLogin != nil {
                let folderPath = "\(imagesPath.path)/\(userLogin ?? "")"
                if fileManager.createFile(atPath: "\(folderPath)/\(imageName)", contents: data, attributes: nil) {
                } else {
                    print ("error 3")
                }
            }
        }
        pickerController.dismiss(animated: true)
        collectionView.reloadData()
    }
}

extension PickerViewController: UICollectionViewDataSource,
          UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell =
       collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as?
            ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = imagesArray[indexPath.item]
        numberOfImage = indexPath.item
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedImageViewController = storyboard.instantiateViewController(identifier:
            String(describing: SelectedImageViewController.self)) as SelectedImageViewController
        selectedImageViewController.modalPresentationStyle = .fullScreen
       
        UserDefaults.standard.setValue(arrayOfNamed, forKey: "arrayOfNamedKey")
        UserDefaults.standard.setValue(numberOfImage, forKey: "numberOfImageKey")
        let imagePath = "\(documentsPath.absoluteURL.absoluteString)Images/\(userLogin ?? "")/\(arrayOfNamed[numberOfImage])".replacingOccurrences(of: "file://", with: "")
        UserDefaults.standard.setValue(imagePath, forKey: "imagePathKey")
        
        selectedImageViewController.selectedImage = imagesArray[indexPath.item]
        
        self.navigationController?.pushViewController(selectedImageViewController, animated: true)

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenWidth = self.view.frame.width
            let itemsPerRow: CGFloat = 2
            let paddingWidth = 20 * (itemsPerRow + 1)
            let availableWidth = screenWidth - paddingWidth
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
}
