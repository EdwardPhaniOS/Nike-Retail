//
//  WelcomeViewController.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/23/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
