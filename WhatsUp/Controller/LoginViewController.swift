//
//  LoginViewController.swift
//  WhatsUp
//
//  Created by Muhamed Alkhatib on 07/09/2020.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseCoreDiagnostics

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        let email=emailTextField.text!
        let password=passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          
            if error == nil {
                print ("login successful")
                //go to chat screen - perform segue
                self?.performSegue(withIdentifier: "LoginToChat", sender: self)
                
            } else {
                print (error?.localizedDescription)
                self!.errorLabel.text=error?.localizedDescription
                
            }
            
            
            // ...
        }    }
}
