//
//  ViewController.swift
//  Ellisys
//
//  Created by Lucas Clahar on 7/2/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

     @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.shadowColor = UIColor.black.cgColor
        loginBtn.layer.shadowOpacity = 0.6
        loginBtn.layer.shadowOffset = .zero
        loginBtn.layer.shadowRadius = 4
        
        registerBtn.layer.cornerRadius = 5
        registerBtn.layer.cornerRadius = 5
        registerBtn.layer.shadowColor = UIColor.black.cgColor
        registerBtn.layer.shadowOpacity = 0.6
        registerBtn.layer.shadowOffset = .zero
        registerBtn.layer.shadowRadius = 4

    }
    
}

