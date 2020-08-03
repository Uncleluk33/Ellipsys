//
//  TableViewCell.swift
//  Ellisys
//
//  Created by Lucas Clahar on 7/15/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import UIKit
import Firebase

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var userNameTextlabel: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView!
    
    
    func setInfo(user: User){
        userNameTextlabel.text = user.first
    }
    
    
    func getProfilePic(user: User){
        
        let profilePicRef = storageRef.child("images/\(user.UID) - profilePic.png")

        
        profilePicRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.userProfilePic.image = image
                
                
                self.userProfilePic.layer.cornerRadius = 30
                self.userProfilePic.clipsToBounds = true
            }
        }
    }

}
