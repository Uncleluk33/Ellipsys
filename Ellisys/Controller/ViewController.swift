//
//  ViewController.swift
//  Ellisys
//
//  Created by Lucas Clahar on 7/2/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var emailToImgTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.shadowColor = UIColor.black.cgColor
        loginBtn.layer.shadowOpacity = 0.6
        loginBtn.layer.shadowOffset = .zero
        loginBtn.layer.shadowRadius = 4
        
        errorLabel.alpha = 0
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
        self.view.frame.origin.y = 0 - keyboardSize.height + (0.17 * self.view.frame.height)
      //  self.emailToImgTop.constant = 0
        
        print(self.view.frame.height)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }

    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                
                if let e = error {
                    
                    self!.errorLabel.text = e.localizedDescription
                    print(e.localizedDescription)
                    
                    UIView.animate(withDuration: 2, animations: {
                   self?.errorLabel.alpha = 1

                    }) { _ in
                        UIView.animate(withDuration: 5) {
                          self?.errorLabel.alpha = 0

                        }
                    }
                    
                }else {
                //  let db = Firestore.firestore()
                    
                    self?.performSegue(withIdentifier: "RegisterToChat", sender: self)
                }
                
            }
            
        }
        
        
    }
    
}


