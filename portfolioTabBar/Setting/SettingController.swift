//
//  SettingController.swift
//  portfolioTabBar
//
//  Created by 임국성 on 08/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
//            let loginController = LoginController()
//            let navController = UINavigationController(rootViewController: loginController)
//            self.present(navController, animated: true, completion: nil)
            if Auth.auth().currentUser == nil {
                presentLoginController()
            }
        } catch let err {
            print("Failed to sign out:", err)
        }
        GIDSignIn.sharedInstance().signOut()
    }
    
    
    private func presentLoginController() {
        DispatchQueue.main.async { // wait until MainTabBarController is inside UI
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginStoryBoard") as UIViewController
            
            self.present(controller, animated: true, completion: nil)
        }
    }
}
