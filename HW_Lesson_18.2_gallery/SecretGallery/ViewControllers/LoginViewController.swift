//
//  ViewController.swift
//  HW Lesson 18.2 (хранилка картинок)
//
//  Created by Pasha on 18.11.2020.
//
// swiftlint:disable all

import UIKit
import SwiftyKeychainKit
import LocalAuthentication

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundLoginView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backgroundSignUpView: UIView!
    @IBOutlet weak var signUPButton: UIButton!
    @IBOutlet weak var backgroundTouchView: UIView!
    
    // MARK: - Public Properties
    
    let keychain = Keychain(service: "pavelKernoga.com.HW-Lesson-18-2")

    // MARK: - Lifestyle function
    
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
        backgroundTouchView.layer.cornerRadius = 10
        backgroundTouchView.alpha = 0.5
        navigationController?.navigationBar.isHidden = true
        passwordTextField?.isSecureTextEntry = true
        loginTextField.text = ""
        passwordTextField.text = ""
   }
    
    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let keychainKey = KeychainKey<String>(key:self.loginTextField?.text ?? "")
        if (self.loginTextField.text != ""), self.passwordTextField.text != "" {
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
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(identifier:
        String(describing: SignUpViewController.self)) as SignUpViewController
        signUpViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @IBAction func touchIDButtonTapped(_ sender: Any) {
        let context: LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "For enter use your fingerprint") { (good, error) in
                if good {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let galleryViewController = storyboard.instantiateViewController(identifier: String(describing: GalleryViewController.self)) as GalleryViewController
                        galleryViewController.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(galleryViewController, animated: true)
                    }
            } else {
                print("Try Again")
            }
            }
        }
    }
    
    // MARK: - Flow functions
    
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

    // MARK: - Extension UITextField

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
