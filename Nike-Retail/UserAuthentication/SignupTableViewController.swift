//
//  SignupTableViewController.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/20/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit
import Firebase

class SignupTableViewController: UITableViewController
{
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var profileImage: UIImage?
    var imagePickerHelper: ImagePickerHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage = UIImage(named: "icon-defaultAvatar")!
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.clipsToBounds = true
        
    }
    
    @IBAction func changeProfilePictureDidTap(_ sender: Any) {
        imagePickerHelper = ImagePickerHelper(viewController: self) { (image) in
            if let image = image {
                self.profileImageView.image = image
                self.profileImage = image
            }
        }
    }
    
    @IBAction func createNewAccountDidTap(_ sender: Any)
    {
        if emailTextField.text != ""
            && (passwordTextField.text?.count)! >= 6
            && isPasswordValid(passwordTextField.text!) == true
            && (usernameTextField.text?.count)! >= 6
            && fullNameTextField.text != ""
        {
            
            let username = usernameTextField.text!
            let email = emailTextField.text!
            let password = passwordTextField.text!
            let fullName = fullNameTextField.text!
            
            Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
                
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
                
                if let result = dataResult {
                    let newUser = User(username: username, uid: result.user.uid, fullname: fullName, email: email, profileImage: self.profileImage!)
                    newUser.save(completion: { (error) in
                        if let error = error {
                            print("ERROR: \(error.localizedDescription)")
                            
                        } else {
                            Auth.auth().signIn(withEmail: email, password: password, completion: { (dataResult, error) in
                                
                                if let error = error {
                                    print("ERROR: \(error.localizedDescription)")
                                } else {
                                    self.dismiss(animated: false, completion: nil)
                                }
                            })
                        }
                    })
                }
            }
            
        } else {
            //show Alert
            let alert = UIAlertController(title: "Error", message: "Your information is not valid", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
