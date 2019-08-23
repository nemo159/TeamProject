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

class SettingController: UIViewController, GIDSignInUIDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var profileImageView : UIImageView!
    @IBOutlet var nicknameLabel : UILabel!
    @IBOutlet var emailLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
    }
    
    @IBAction func transformButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            if Auth.auth().currentUser == nil {
                presentLoginController()
            }
        } catch let err {
            print("Failed to sign out:", err)
        }
        GIDSignIn.sharedInstance().signOut()
    }
    
    @IBAction func ProfileEditButtonPressed(_ sender: UIButton) {
    }
    
    
    private func presentLoginController() {
        DispatchQueue.main.async { // wait until MainTabBarController is inside UI
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginStoryBoard") as UIViewController
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func initLayout() {
        let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x58C1F9)
        //ImageView
        profileImageView.setBorderColor(width: 0.5, color: myColor, corner: 140 / 2)
    }
    
    // MARK: - Tableview Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath)
        return cell
    }
    
}


//멘토일때 지역/분야/시간 관리 및 본인 포스트 관리
