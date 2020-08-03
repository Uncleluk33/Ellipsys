//
//  RegistrationViewController.swift
//  Ellisys
//
//  Created by Lucas Clahar on 7/2/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import UIKit
import Firebase
class RegistrationViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextFeild: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        registerBtn.layer.cornerRadius = 5
        registerBtn.layer.cornerRadius = 5
        registerBtn.layer.shadowColor = UIColor.black.cgColor
        registerBtn.layer.shadowOpacity = 0.6
        registerBtn.layer.shadowOffset = .zero
        registerBtn.layer.shadowRadius = 4
        
        errorLabel.alpha = 0
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    
                    self.errorLabel.text = e.localizedDescription
                    
    

                    UIView.animate(withDuration: 2, animations: {
                        self.errorLabel.alpha = 1

                     }) { _ in
                         UIView.animate(withDuration: 5) {
                            self.errorLabel.alpha = 0

                         }
                     }
                    
                    
                }else {
                    // add first and last name
                    let db = Firestore.firestore()
                    
                    
                    db.collection("testusers").addDocument( data:["first": self.firstNameTextField.text, "last": self.lastNameTextFeild.text, "UID": authResult?.user.uid]) { (error) in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                    }
                    
                    // Navigate to chat viewController
                    self.navigationController?.popViewController(animated: true)

                }
            }
            
        }
        
        
        
    }
    

}
