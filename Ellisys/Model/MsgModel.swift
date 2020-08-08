//
//  MsgModel.swift
//  Ellisys
//
//  Created by Lucas Clahar on 7/30/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import Foundation
import MessageKit

struct Message {
    var sender: String
    var Receiver: String
    var body: String
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}


struct Msg: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
}
