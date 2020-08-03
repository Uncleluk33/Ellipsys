//
//  UserModel.swift
//  Ellisys
//
//  Created by Lucas Clahar on 7/14/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let storage = Storage.storage()
let storageRef = storage.reference()






struct User {
    var UID: String
    var first: String
    var last: String
    
}
