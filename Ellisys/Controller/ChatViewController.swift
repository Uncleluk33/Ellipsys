//
//  ChatViewController.swift
//  Ellisys
//
//  Created by Lucas Clahar on 7/27/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import UIKit
import Firebase
import MessageKit
import InputBarAccessoryView

class ChatViewController:  MessagesViewController, MessagesDisplayDelegate, MessagesLayoutDelegate, MessagesDataSource{
    
    
    var userID1: String!
    var userID2: String!
    var userID2Name: String!
    
    
    var currentUser: Sender = Sender(senderId: "", displayName: "")
    var otherUser: Sender = Sender(senderId: "", displayName: "")
    var userMessages: [MessageType] = []
    
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var senderTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // chatTableView.dataSource = self
        // chatTableView.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        messageInputBar.delegate = self
        
        
        overrideUserInterfaceStyle = .light

        
        currentUser = Sender(senderId: userID1, displayName: "Luke")
        otherUser = Sender(senderId: userID2, displayName: userID2Name)
        self.title = userID2Name
        DispatchQueue.main.async {
            let db = Firestore.firestore()
            
            db.collection("Chat").order(by: "date").addSnapshotListener { (querySnapshot, err) in
                
                self.userMessages = []
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        
                        /*let newMsg = Message(sender: data["sender"] as! String, Receiver: data["receiver"] as! String, body: data["msg"] as! String)*/
                        var sender: Sender
                        
                        if data["sender"] as! String == self.userID1 {
                            sender = self.currentUser
                        }else {
                            sender = self.otherUser
                        }
                        
                        
                        let newMsg = Msg(sender: sender, messageId: "", sentDate: Date().addingTimeInterval(-84500), kind: .text(data["msg"] as! String))
                        
                        if (data["sender"] as! String  == self.userID1 && data["receiver"] as! String == self.userID2 ) || (data["sender"] as! String  == self.userID2 && data["receiver"] as! String == self.userID1)
                        {
                            
                            self.userMessages.append(newMsg)
                            
                        }
                        
                    }
                    
                    print(self.userID1)
                    print(self.userID2)
                    
                    // self.chatTableView.reloadData()
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                    print(self.userMessages)
                    
                    
                }
                
            }
        }
        
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
        self.view.frame.origin.y = 0 - keyboardSize.height + (0.08 * self.view.frame.height)
        //self.emailToImgTop.constant = 0
        
        print(self.view.frame.height)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    
    
    @IBAction func closeBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func senderBtnPressed(_ sender: Any) {
        
        let db = Firestore.firestore()
        
        db.collection("Chat").addDocument(data: ["msg" : senderTextField.text!,
                                                 "sender" : userID1!, "receiver": userID2!])
        
        
    }
    
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return userMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return userMessages.count
    }
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let db = Firestore.firestore()
        
        db.collection("Chat").addDocument(data: ["msg" : text,
                                                 "sender" : userID1!, "receiver": userID2!, "date": Date().timeIntervalSince1970])
         inputBar.inputTextView.text = ""
    }
}

/*
 extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 userMessages.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 let msg = userMessages[indexPath.row]
 
 
 if msg.sender == userID1 {
 let cell = tableView.dequeueReusableCell(withIdentifier: "senderMsgCell", for: indexPath) as! ChatSenderCell
 
 cell.setInfo(data: msg.body
 )
 return cell
 }else if msg.sender == userID2{
 let cell = tableView.dequeueReusableCell(withIdentifier: "msgReceiveCell", for: indexPath) as! ChatReceiveCell
 
 cell.setInfo(data: msg.body
 )
 return cell
 }
 return UITableViewCell()
 }
 
 
 }
 */
