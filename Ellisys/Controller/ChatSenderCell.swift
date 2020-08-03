//
//  ChatSenderCell.swift
//  Ellisys
//
//  Created by Lucas Clahar on 7/30/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import UIKit

class ChatSenderCell: UITableViewCell {

    
    @IBOutlet weak var msgLabel: UILabel!
    
    func setInfo(data: String)  {
        msgLabel.text = data
    }
    
}
