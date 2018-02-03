//
//  User.swift
//  Paung Chat
//
//  Created by Zulwiyoza Putra on 03/02/18.
//  Copyright © 2018 Reblood. All rights reserved.
//

import Foundation

class User {
    let id: String
    let email: String
    
    init(id: String = FirebaseController.Users.shared.generateFirebaseIdentifier(for: "Users"), email: String) {
        self.id = id
        self.email = email
    }
}

