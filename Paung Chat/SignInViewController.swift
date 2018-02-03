//
//  SignInViewController.swift
//  Paung Chat
//
//  Created by Zulwiyoza Putra on 03/02/18.
//  Copyright © 2018 Reblood. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
    @IBAction func signIn(_ sender: Any) {
        self.view.endEditing(true)
        loadingView.present()
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        FirebaseController.shared.signIn(email: email, password: password) { (user, error) in
            guard error == nil else {
                print(error.debugDescription)
                self.loadingView.dismiss()
                return
            }
            self.loadingView.dismiss()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "SignUp", bundle: nil)
        
        guard let controller = storyboard.instantiateInitialViewController() else {
            return
        }
        
        guard let navigationController = self.navigationController else {
            return
        }
        
        navigationController.pushViewController(controller, animated: true)
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
