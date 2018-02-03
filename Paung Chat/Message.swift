//
//  Chats.swift
//  Paung Chat
//
//  Created by Zulwiyoza Putra on 03/02/18.
//  Copyright © 2018 Reblood. All rights reserved.
//

import Foundation

class Message {
    let id: String
    let created: Date
    let text: String
    let sender: User
    let target: User
    
    init(id: String = FirebaseController.Messages.shared.generateFirebaseIdentifier(for: "messages"), created: Date = Date(), text: String, sender: User, target: User) {
        self.id = id
        self.created = created
        self.text = text
        self.sender = sender
        self.target = target
    }
}
