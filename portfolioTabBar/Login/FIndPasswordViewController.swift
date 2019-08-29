//
//  FIndPasswordViewController.swift
//  portfolioTabBar
//
//  Created by 임국성 on 29/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase

class FIndPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                print("Error : \(error!)")
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

    
}
