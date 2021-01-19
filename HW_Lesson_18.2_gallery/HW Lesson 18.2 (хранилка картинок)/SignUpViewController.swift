//
//  SignUpViewController.swift
//  HW_Lesson_18.2
//
//  Created by Pasha on 18.01.2021.
//
// swiftlint:disable all

import UIKit
import SwiftyKeychainKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButtonBackgroundView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signUpBackgroundView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    let keychain = Keychain(service: "pavelKernoga.com.HW-Lesson-18-2")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.delegate = self
        passwordTextField.delegate = self
        confirmPassTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        imageView.image = UIImage(named: "background_image")
        backButtonBackgroundView.alpha = 0.3
        backButtonBackgroundView.layer.cornerRadius = 10
        signUpBackgroundView.alpha = 0.5
        signUpBackgroundView.layer.cornerRadius = 10
        passwordTextField.isSecureTextEntry = true
        confirmPassTextField.isSecureTextEntry = true
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let keychainKey = KeychainKey<String>(key: self.loginTextField?.text ?? "")
        if self.passwordTextField?.text == self.confirmPassTextField?.text {
            if (try? self.keychain.get(keychainKey)) != nil {
                self.openErrorRegistrationAlert()
            } else {
                let password = self.passwordTextField?.text ?? ""
                try? self.keychain.set(password, for: keychainKey)
                print("user \(self.loginTextField?.text ?? "") saved")
                self.openSuccessfulSignUpAlert()
            }
        } else {
            openErrorConfirmPassword()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openErrorConfirmPassword() {
        let alert = UIAlertController(title: "Error", message: "Check the entered password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func openErrorRegistrationAlert() {
        let alert = UIAlertController(title: "Error", message: "This login is already registered. Please, create a new login.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func openSuccessfulSignUpAlert() {
        let alert = UIAlertController(title: "Сongratulations!", message: "Registration completed successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
