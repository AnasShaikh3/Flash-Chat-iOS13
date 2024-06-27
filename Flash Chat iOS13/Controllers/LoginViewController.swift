//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        let emailTxt = emailTextfield.text
        let passwordTxt = passwordTextfield.text
        
        if let email = emailTxt , let password = passwordTxt {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let err = error {
                    print(err.localizedDescription)
                }else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }

    }
    
}
