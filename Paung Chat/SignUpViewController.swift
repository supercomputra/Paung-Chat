//
//  SignUpViewController.swift
//  Paung Chat
//
//  Created by Zulwiyoza Putra on 03/02/18.
//  Copyright © 2018 Reblood. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    lazy var loadingView: LoadingView = {
        let window = UIApplication.shared.keyWindow!
        let view = LoadingView(frame: window.frame)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: Any) {
        self.view.endEditing(true)
        loadingView.present()
        guard let email = emailTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text, password == repeatPassword else {
            loadingView.dismiss()
            return
        }
        let user = User(email: email)
        FirebaseController.Users.shared.post(user: user, password: password) { (user, error) in
            if error == nil {
                self.loadingView.dismiss()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
