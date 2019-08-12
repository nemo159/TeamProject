//
//  LoginViewController.swift
//  portfolioTabBar
//
//  Created by 임국성 on 17/07/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import KakaoOpenSDK

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet weak var btnGoogleSignIn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        GIDSignIn.sharedInstance().uiDelegate = self
//    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: pwTextField.text!) { (user, error) in
            if user != nil{
                print("login success")
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            else{
                print("login fail")
            }
        }
        
    }
    
    //Kakaotalk Login Button Action Add
    @IBAction func kakaotalkLogin(_ sender: KOLoginButton) {
        KOSession.shared()?.open(completionHandler: {(error) in
            if error != nil || !(KOSession.shared()?.isOpen())! {
                self.presentHomeController()
                return
            }
        })
    }
    
    //Kakaotalk Login 완료 시 화면이동
    private func presentHomeController() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "homeVC") as UIViewController
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func myExit(_ sender: UIStoryboardSegue) {
        
    }

}
