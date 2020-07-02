//
//  LoginScreenViewController.swift
//  Ellisys
//
//  Created by Lucas Clahar on 7/2/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.shadowColor = UIColor.black.cgColor
        loginBtn.layer.shadowOpacity = 0.6
        loginBtn.layer.shadowOffset = .zero
        loginBtn.layer.shadowRadius = 4
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
