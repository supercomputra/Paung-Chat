//
//  FirebaseController.swift
//  Paung Chat
//
//  Created by Zulwiyoza Putra on 03/02/18.
//  Copyright © 2018 Reblood. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FirebaseViews {
    var reference: DatabaseReference!
    
    init() {
        self.reference = Database.database().reference()
    }
    
    func generateFirebaseIdentifier(for child: String) -> String {
        let key = self.reference.child(child).childByAutoId().key
        return key
    }
}

class FirebaseController {
    
    static let shared = FirebaseController()
    
    func getCurrentUser() -> User? {
        guard let firebaseUser = Auth.auth().currentUser else {
            return nil
        }
        let user = User(id: firebaseUser.uid, email: firebaseUser.email ?? "")
        return user
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch let error {
            throw error
        }
    }
    
    func signIn(email: String, password: String, completionHandler: @escaping (User?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (firebaseUser, error) in
            guard let firebaseUser = firebaseUser, let email = firebaseUser.email else {
                return
            }
            
            let user = User(email: email)
            
            completionHandler(user, nil)
        }

    }
    
    class Messages: FirebaseViews {
        
        static let shared = Messages()
        
        func post(message: Message, completionHandler: @escaping (Error?) -> Void) {
            let messageDictionary: [String: Any] = [
                "created": message.created.description,
                "text": message.text
            ]
            
            let childUpdates = [
                "/messages/\(message.id)": messageDictionary,
                "/users/\(message.sender.id)/messages/\(message.id)/": messageDictionary,
                "/users/\(message.target.id)/inboxes/\(message.id)/": messageDictionary
            ]
            self.reference.updateChildValues(childUpdates) { (error, reference) in
                completionHandler(error)
            }
        }
        
        typealias MessegeHandler =  (([Message]) -> Void)
        func get(sender: User, target: User, completionHandler: @escaping MessegeHandler) {
            
            var messages: [Message] = []
            
            self.reference.child("users").child(sender.id).child("messages").observe(.childAdded) { (snapshot) in
                
                print(snapshot)
                
                guard let value = snapshot.value as? [String: Any?], let text = value["text"] as? String else {
                    return
                    
                }
                
                let message = Message(id: snapshot.key, created: Date(), text: text, sender: sender, target: target)
                messages.append(message)
                
                completionHandler(messages)
            }
        }
    }
    
    class Users: FirebaseViews {
        
        static let shared = Users()
        
        typealias UserHandler = ((User?, Error?) -> Void)
        func post(user: User, password: String, completionHandler: @escaping UserHandler) {
            
            let userDictionary: [String: Any] = [
                "email": user.email
            ]
            
            Auth.auth().createUser(withEmail: user.email, password: password) { (user, error) in
                guard let user = user else {
                    guard let error = error else {
                        completionHandler(nil, nil)
                        return
                    }
                    completionHandler(nil, error)
                    return
                }
                
                let childUpdates = [
                    "/users/\(user.uid)": userDictionary,
                ]
                
                self.reference.updateChildValues(childUpdates, withCompletionBlock: { (error, reference) in
                    print(error.debugDescription)
                    guard error == nil, let email = user.email else {
                        completionHandler(nil, error)
                        return
                    }
                    let user = User(id: user.uid, email: email)
                    completionHandler(user, error)
                })
            }
        }
        

        func get(completionHandler: @escaping ([User]) -> Void) {
            var users: [User] = []
            
            self.reference.child("users").observeSingleEvent(of: .value) { (snapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    guard let value = snap.value as? [String: Any?], let email = value["email"] as? String else {
                        return
                    }
                    
                    let user = User(id: snap.key, email: email)
                    users.append(user)
                }
                
                completionHandler(users)
            }
        }
    }
    
}
