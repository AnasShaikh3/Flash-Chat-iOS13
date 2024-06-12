//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let emailTxt = emailTextfield.text
        let passwordTxt = passwordTextfield.text
        if let email = emailTxt , let password = passwordTxt {
            
            
            PhoneAuthProvider.provider()
              .verifyPhoneNumber(email, uiDelegate: nil) { verificationID, error in
                  if let error = error {
                    print(error.localizedDescription)
                    return
                  }
                  // Sign in using the verificationID and the code sent to the user
                  // ...
              }

            
            
//            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//                if let err = error {
//                    print(err.localizedDescription)
//                }else {
//                    self.performSegue(withIdentifier: "RegisterToChat", sender: self)
//                    print(authResult)
//                }
//            }
        }

    }
    
}

