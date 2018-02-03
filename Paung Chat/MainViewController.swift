//
//  TableViewController.swift
//  Paung Chat
//
//  Created by Zulwiyoza Putra on 03/02/18.
//  Copyright © 2018 Reblood. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainViewController: UITableViewController, ContactPickerDelegate {
    
    private var messages: [Message] = []
    
    private var target: User?
    
    lazy var loadingView: LoadingView = {
        let window = UIApplication.shared.keyWindow!
        let view = LoadingView(frame: window.frame)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleAuthentication()
        
        
    }
    
    func loadMessages() {
        let user = FirebaseController.shared.getCurrentUser()
        if self.target != nil {
            FirebaseController.Messages.shared.get(sender: user!, target: self.target!, completionHandler: { (messages) in
                self.messages = []
                self.messages = messages
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handleAuthentication()
        
        if target == nil {
            setTitle(title: "To:", subtitle: "None")
        } else {
            setTitle(title: "To:", subtitle: (target?.email)!)
            self.loadMessages()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let chat = messages[indexPath.row]
        cell.textLabel?.text = chat.text
        cell.detailTextLabel?.text = chat.created.description
        return cell
    }
    
    func setContact(_ contact: User) {
        self.target = contact
    }
    
    func handleAuthentication() {
        if FirebaseController.shared.getCurrentUser() == nil {
            
            let storyboard = UIStoryboard.init(name: "SignIn", bundle: nil)
            
            guard let controller = storyboard.instantiateInitialViewController() else {
                return
            }

            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func addMessage(_ sender: Any) {
        
        guard self.target != nil else {
            self.presentContactPicker()
            return
        }
        
        let controller = UIAlertController(title: "Create Message", message: nil, preferredStyle: .alert)
        
        controller.addTextField { (textField) in
            textField.placeholder = "Message"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { (action) in
            
            guard let textFields = controller.textFields else {
                return
            }
            
            let messageTextField = textFields[0]

            
            guard let sender = FirebaseController.shared.getCurrentUser() else {
                return
            }
            
            guard let target = self.target else {
                return
            }
            
            guard let messageText = messageTextField.text else {
                return
            }
            
            let message = Message(created: Date(), text: messageText, sender: sender, target: target)
            
            
            FirebaseController.Messages.shared.post(message: message, completionHandler: { (error) in
                guard let error = error else {
                    return
                }
                print(error)
                
            })
        }
        controller.addAction(cancelAction)
        controller.addAction(sendAction)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func presentContactPicker() {
        self.loadingView.present()
        FirebaseController.Users.shared.get(completionHandler: { (users) in
            self.loadingView.dismiss()
            let storyboard = UIStoryboard(name: "Contacts", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() as? ContactsViewController else {
                return
            }
            viewController.contacts = users
            viewController.contactPickerDelegate = self
            guard let navigationController = self.navigationController else {
                return
            }

            navigationController.pushViewController(viewController, animated: true)
        })
    }
    
    @IBAction func settings(_ sender: Any) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            do {
                try FirebaseController.shared.signOut()
                self.handleAuthentication()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(signOutAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func setTitle(title:String, subtitle:String) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.black
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        self.navigationItem.titleView = titleView
    }
}
