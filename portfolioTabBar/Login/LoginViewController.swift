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
    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet weak var btnGoogleSignIn: GIDSignInButton!
    @IBOutlet weak var kakaoName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
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
        guard let session = KOSession.shared() else {return}
        if session.isOpen() {
            session.close()
        }
        session.open(completionHandler: { (error) -> Void in
            if !session.isOpen() {
                if let error = error as NSError? {
                    switch error.code {
                    case Int(KOErrorCancelled.rawValue):
                        break
                    default:
                        print(error.description)
                    }
                }
            } else {
                guard let session = KOSession.shared() else {return}
                if session.isOpen() {
                    let _: KOUserMe?
                    _ = KOSessionTask.userMeTask(completion: {(error, kakaoUser) in
                        if let error = error as NSError? {
                            print("error : \(error)")
                            return
                        } else {
                            //                    let email = kakaoUser?.account?.email
                            let nickname = kakaoUser?.nickname
                            
                            if let url = kakaoUser?.profileImageURL?.absoluteString {
                                print(url)
                                self.profileImageView.loadImage(urlString: url)
                            }
//                            self.profileImageView.loadImage(urlString: (kakaoUser?.profileImageURL!.absoluteString)!)
                            self.kakaoName.text = nickname
                        }
                    })
                }
//                self.presentHomeController()
            }
        })
    }


    
    //Kakaotalk Login 완료 시 화면이동
    private func presentHomeController() {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "SelectMentorMentee") as UIViewController
            self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func myExit(_ sender: UIStoryboardSegue) {
        
    }

}
