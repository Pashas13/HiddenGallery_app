//
//  ViewController.swift
//  HW Lesson 18.2 (хранилка картинок)
//
//  Created by Pasha on 18.11.2020.
//
// swiftlint:disable all

import UIKit
import SwiftyKeychainKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundLoginView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backgroundSignUpView: UIView!
    @IBOutlet weak var signUPButton: UIButton!
    
    let keychain = Keychain(service: "pavelKernoga.com.HW-Lesson-18-2")

    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        imageView.image = UIImage(named: "background_image")
        backgroundLoginView.layer.cornerRadius = 10
        backgroundLoginView.alpha = 0.5
        backgroundSignUpView.layer.cornerRadius = 10
        backgroundSignUpView.alpha = 0.5
        navigationController?.navigationBar.isHidden = true
        passwordTextField?.isSecureTextEntry = true
        
        loginTextField.text = ""
        passwordTextField.text = ""
   }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let keychainKey = KeychainKey<String>(key:self.loginTextField?.text ?? "")
        if (try? self.keychain.get(keychainKey)) == self.passwordTextField?.text {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let galleryViewController = storyboard.instantiateViewController(identifier: String(describing: GalleryViewController.self)) as GalleryViewController
            galleryViewController.modalPresentationStyle = .fullScreen
            UserDefaults.standard.setValue(self.loginTextField?.text, forKey: "Login")
            self.navigationController?.pushViewController(galleryViewController, animated: true)
        } else {
            self.openErrorSignInAlert()
            return
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(identifier:
        String(describing: SignUpViewController.self)) as SignUpViewController
        signUpViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }

    func openErrorSignInAlert() {
        let alert = UIAlertController(title: "Error", message: "This user was not found",
        preferredStyle: .alert)
        
        let enterAction = UIAlertAction(title: "Try again", style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(enterAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
