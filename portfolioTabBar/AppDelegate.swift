//
//  AppDelegate.swift
//  portfolioTabBar
//
//  Created by 임국성 on 17/07/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
//Google Login을 위해 GIDSignInDelegate 추가 -> Google Api에서 OAuth 설정도 해야함
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{

    var window: UIWindow?
    
    var globalFlag: Bool? = false
        
    //Google Login
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                _ = Auth.auth().addStateDidChangeListener { (auth, user) in
                    if let user = user {
                        let uid = user.uid
                        let email = user.email
                        let nickname = user.displayName
                        let photoUrl = user.photoURL?.absoluteString
                        let ref:DatabaseReference = Database.database().reference()
                        let itemRef = ref.child("users/\(uid)")
                        itemRef.setValue(["nickname": nickname, "email": email, "profileImageUrl": photoUrl])
                    }
                }
                
                if let controller = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SelectMentorMentee") as? UIViewController {
                    if let window = self.window, let rootViewController = window.rootViewController {
                        var currentController = rootViewController
                        while let presentedController = currentController.presentedViewController {
                            currentController = presentedController
                        }
                        currentController.present(controller, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        //Google Login
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    //Google Login - 이 메소드는 GIDSignIn 인스턴스의 handleURL 메소드를 호출하며 이 메소드는 애플리케이션이 인증 절차가 끝나고 받는 URL를 적절히 처리합니다.
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                              sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                              annotation: [:])
    }
    //Google Login - 앱을 iOS 8 이상에서 실행
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {    return GIDSignIn.sharedInstance().handle(url,
                                                                                                                                                                     sourceApplication: sourceApplication,
                                                                                                                                                                     annotation: annotation)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
}

