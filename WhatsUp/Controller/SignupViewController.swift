//
//  SignupViewController.swift
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

class SignupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

 
    }
    

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signupPressed(_ sender: UIButton) {
        
        let email=emailTextField.text!
        let password=passwordTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
          
            if error == nil {
                print ("User is registerd succesfully")
                //go to chatt - perform segue
                self.performSegue(withIdentifier: "SignupToChat", sender: self)
                
            } else {
                print (error.debugDescription)
                errorLabel.text=error?.localizedDescription
            }
            
            
            
        }
    }
}
