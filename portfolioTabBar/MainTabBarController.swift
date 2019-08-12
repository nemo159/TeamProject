//
//  MainTabBarController.swift
//  portfolioTabBar
//
//  Created by 임국성 on 17/07/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    @IBOutlet var mainTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mainTabBar.tintColor =
        mainTabBar.unselectedItemTintColor = UIColor.darkGray
        tabBar.isTranslucent = false
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
//            FirstViewController()
        }
    }
    
    private func presentLoginController() {
        DispatchQueue.main.async { // wait until MainTabBarController is inside UI
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginStoryBoard") as UIViewController
            
            self.present(controller, animated: true, completion: nil)
        }
    }

//    private func pushFirstController() {
//        DispatchQueue.main.async { // wait until MainTabBarController is inside UI
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "LoginStoryBoard") as UIViewController
//
//            self.present(controller, animated: true, completion: nil)
//        }
//    }

}
