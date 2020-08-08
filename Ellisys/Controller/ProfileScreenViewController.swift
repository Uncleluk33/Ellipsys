//
//  ProfileScreenViewController.swift
//  Ellisys
//
//  Created by Lucas Clahar on 8/8/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import UIKit
import Firebase

class ProfileScreenViewController: UIViewController {
    
    
    @IBOutlet weak var profileTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { (querySnapshot, err) in
            if let err = err {
                print(err)
            }else {
                for document in querySnapshot!.documents {

                let data = document.data()
                
                if data["UID"] as! String == Auth.auth().currentUser!.uid {
                    
                    let user = User(UID: data["UID"] as! String, first: data["first"] as! String, last: data["last"] as! String)
                    
                    self.profileTextLabel.text = "Welcome \(user.first)"
                    
                }
            }
            
        }
        
}
}
}
