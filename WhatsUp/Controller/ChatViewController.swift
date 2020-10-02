//
//  ChatViewController.swift
//  WhatsUp
//
//  Created by Muhamed Alkhatib on 08/09/2020.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseCoreDiagnostics

class ChatViewController: UIViewController {
    
    var messages = [Message]()
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        messageTextField.delegate=self
        self.tableView.separatorStyle = .none

        
        tableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        
        tableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        
        
        readMessage()

        navigationItem.setHidesBackButton(true, animated: true)
    }
    

    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          self.navigationController?.popToRootViewController(animated: true)

            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBAction func sendPressed(_ sender: UIButton) {
                  

        
        let message = Message (sender: Auth.auth().currentUser?.email, body: messageTextField.text!)
        
        saveMessage(message)
        
        
        messageTextField.text=nil

    }
    

}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderTableViewCell
            
            cell.label.text=messages[indexPath.row].body
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverTableViewCell
            
            cell.label.text=messages[indexPath.row].body
            
            return cell
            
        }
            
        
        
        
        
    }
    
    
    func saveMessage(_ message: Message) {
        
        // Add a new document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("messages").addDocument(data: [
            "body": message.body!,
            "sender": message.sender!,
            "time": Date().timeIntervalSince1970
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }

        
    }
    
    func readMessage(){
        
        db.collection("messages").order(by: "time").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self.messages.removeAll()
            for doc in documents {
                let msgBody=doc.data()["body"] as! String
                let msgSender=doc.data()["sender"] as! String
                
                let msg=Message(sender: msgSender, body: msgBody)
                self.messages.append(msg)
                
                self.tableView.reloadData()
                
                
            }
            
            let indexPath=IndexPath(row: self.messages.count-1, section: 0)
            
            if indexPath.row > 5{
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            
            
        }
    }
    
 
}


extension ChatViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let message = Message (sender: Auth.auth().currentUser?.email, body: messageTextField.text!)
        
        saveMessage(message)
        
        
        messageTextField.text=nil
        
        return true
    }
}
