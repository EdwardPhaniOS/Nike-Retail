//
//  LoginViewController.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/25/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginDidTap(_ sender: Any)
    {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (dataResult, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                  self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
