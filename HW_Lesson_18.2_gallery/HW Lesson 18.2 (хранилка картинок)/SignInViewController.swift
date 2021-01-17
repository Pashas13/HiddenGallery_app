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

    private var loginTextField: UITextField?
    private var passwordTextField: UITextField?

    let keychain = Keychain(service: "pavelKernoga.com.HW-Lesson-18-2")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

       openAuthorizationAlert()
   }
    
    func openAuthorizationAlert() {

        let alert = UIAlertController(title: "Sign In", message: "Enter your login and password", preferredStyle: .alert)
        
        let enterAction = UIAlertAction(title: "Enter", style: .default, handler: { (_) in
            let keychainKey = KeychainKey<String>(key:self.loginTextField?.text ?? "")

            if (try? self.keychain.get(keychainKey)) != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let pickerViewController = storyboard.instantiateViewController(identifier:
            String(describing: PickerViewController.self)) as PickerViewController
                pickerViewController.modalPresentationStyle = .fullScreen
            
                UserDefaults.standard.setValue(self.loginTextField?.text, forKey: "Login")
                
                self.navigationController?.pushViewController(pickerViewController, animated: true)
                
            } else {
                self.openErrorSignInAlert()
                return
            }
        })

        let registrationAction = UIAlertAction(title: "Registration", style: .default, handler: { (_) in
            let keychainKey = KeychainKey<String>(key: self.loginTextField?.text ?? "")
            
            if (try? self.keychain.get(keychainKey)) != nil {
                self.openErrorRegistrationAlert()
            } else {
                let password = self.passwordTextField?.text ?? ""
                try? self.keychain.set(password, for: keychainKey)
                print("user \(self.loginTextField?.text ?? "") saved")
                self.openAuthorizationAlert()
            }
        })

        alert.addTextField { (login) in
            login.placeholder = "Login"
            self.loginTextField = login
        }

        alert.addTextField { (password) in
            password.placeholder = "Password"
            password.isSecureTextEntry = true
            self.passwordTextField = password
        }

        alert.addAction(enterAction)
        alert.addAction(registrationAction)
        present(alert, animated: true, completion: nil)
    }
    
    func openErrorRegistrationAlert() {
        let alert = UIAlertController(title: "Error", message: "This login is already registered. Please, create a new login.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.openAuthorizationAlert()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func openErrorSignInAlert() {
        let alert = UIAlertController(title: "Error", message: "You have written the wrong password",
        preferredStyle: .alert)
        
        let enterAction = UIAlertAction(title: "Try again", style: .default, handler: { (_) in
            self.openAuthorizationAlert()
        })

        alert.addAction(enterAction)
        present(alert, animated: true, completion: nil)
    }
}
