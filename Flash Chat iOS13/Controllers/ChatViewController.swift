//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()

    
    var Messages = [
        Message(sender: "demo@gmail.com", body: "hi!"),
        Message(sender: "1@2.com", body: "hi!"),
        Message(sender: "demo@gmail.com", body: "how are you?"),
    ]
    
    override func viewDidLoad() {
        title = K.appName
        tableView.dataSource  = self
        tableView.delegate = self
        navigationItem.hidesBackButton  = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        super.viewDidLoad()
        loadMessage()

    }
    
    func loadMessage (){
        Messages = []
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { data, err in
            if let error = err {
                print(error)
            }else {
                self.Messages = (data?.documents.map({ QueryDocumentSnapshot in
                    let mSender = QueryDocumentSnapshot[K.FStore.senderField] as! String
                    let mBody = QueryDocumentSnapshot[K.FStore.bodyField] as! String
                    return Message(sender: mSender, body: mBody)
                }))!
                
                self.tableView.reloadData()
                let indexPath = IndexPath(row: self.Messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }   
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let mssg = messageTextfield.text , let email = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName)
                .addDocument(data: [
                    K.FStore.senderField : email,
                    K.FStore.bodyField : mssg,
                    K.FStore.dateField : NSDate().timeIntervalSince1970
                ]) { error in
                    if let e = error {
                        print(e)
                    }
                }
            messageTextfield.text = ""
        }
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = Messages[indexPath.row].body
        
        cell.youAvatar.isHidden = true
        cell.meAvatar.isHidden = true
        cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
        cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        
        if Messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            cell.meAvatar.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }else {
            cell.youAvatar.isHidden = false
        }
        
        return cell
    }
}

extension ChatViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
