//
//  ContactsViewController.swift
//  Paung Chat
//
//  Created by Zulwiyoza Putra on 03/02/18.
//  Copyright © 2018 Reblood. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
    
    var contacts: [User]!
    
    var contactPickerDelegate: ContactPickerDelegate?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact.email
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]
        guard let delegate = self.contactPickerDelegate else {
            return
        }
        delegate.setContact(contact)
        guard let navigationController = self.navigationController else {
            return
        }
        navigationController.popViewController(animated: true)
        
    }
}
