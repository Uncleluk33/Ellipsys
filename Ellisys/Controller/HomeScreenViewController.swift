//
//  LoginScreenViewController.swift
//  Ellisys
//
//  Created by Lucas Clahar on 7/2/20.
//  Copyright © 2020 Tsahai Clahar. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var users = [User]()
    var userAtIndex: String!
    var userAtIndexName: String!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? ChatViewController {
            target.userID1 = Auth.auth().currentUser!.uid
            target.userID2 = userAtIndex
            target.userID2Name = userAtIndexName
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        overrideUserInterfaceStyle = .light

        
        //get current user info
        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            let db = Firestore.firestore()
            
            
            db.collection("users").whereField("UID", isEqualTo: Auth.auth().currentUser!.uid)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        //                    for document in querySnapshot!.documents {
                        //                       let data = document.data()
                        //                       let myUser = User(UID: data["UID"] as! String, first: data["first"] as! String, last: data["last"] as! String)
                        //                    }
                        let myUser = Auth.auth().currentUser!
                        
                    }
            }   // get all users info and create user object
            db.collection("users").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let data = document.data()
                        
                        if data["UID"] as! String != Auth.auth().currentUser!.uid {
                            
                            let user = User(UID: data["UID"] as! String, first: data["first"] as! String, last: data["last"] as! String)
                            self.users.append(user)
                            
                            // print("Data == \(data["UID"] as! String)")
                            //print("Current User == \(self.myUser.UID)")
                        }
                    }
                    // print("here are the useres \(self.users)")
                    
                    //load data into tableview
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                        let storage = Storage.storage()
                        let storageRef = storage.reference()
                        
                        let profilePicRef = storageRef.child("images/\(Auth.auth().currentUser!.uid) - profilePic.png")
                        
                        
                        
                        profilePicRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                            } else {
                                // Data for "images/island.jpg" is returned
                                let image = UIImage(data: data!)
                                self.userImage.setBackgroundImage(image, for: UIControl.State.normal)
                                
                            }
                        }
                    }
                    
                }
            }
            
        } else {
            // No user is signed in.
            // ...
        }
        
        
        userImage.layer.cornerRadius = 20
        userImage.clipsToBounds = true
        
    }
    @IBAction func logOUtBtn(_ sender: Any) {
        
       for controller in self.navigationController!.viewControllers as Array {
           if controller.isKind(of: ViewController.self) {
               self.navigationController!.popToViewController(controller, animated: true)
               break
           }
       }
        print("logOUt btn pressed")
    }
}



extension HomeScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  print("\(users[indexPath.row].UID) + \(Auth.auth().currentUser!.uid)")
        

        self.userAtIndex = users[indexPath.row].UID
        self.userAtIndexName = users[indexPath.row].first
        
        //performSegue(withIdentifier: "ChatScreen", sender: Any?.self)
        
        let vc = ChatViewController()
        vc.title = "Chat"
        vc.userID1 = Auth.auth().currentUser!.uid
        vc.userID2 = userAtIndex
        vc.userID2Name = userAtIndexName
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.setInfo(user: user)
        cell.getProfilePic(user: user)
        return cell
    }
    
    
}


extension HomeScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    //add image
    @IBAction func photoSelect(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .alert)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        userImage.setBackgroundImage(image, for: UIControl.State.normal)
        picker.dismiss(animated: true, completion: nil)
        
        let data = image.pngData()!
        
        let storage = Storage.storage()
        // Create a root reference
        let storageRef = storage.reference()
        
        
        // Data in memory
        
        
        // Create a reference to the file you want to upload
        let profilePicRef = storageRef.child("images/\(Auth.auth().currentUser!.uid) - profilePic.png")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = profilePicRef.putData(data, metadata: nil) { (metadata, error) in
            
            // You can also access to download URL after upload.
            profilePicRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                
                
            }
        }
        
    }
    
    
    // store image to firebase
}
