//
//  FirebaseUtilities.swift
//  portfolioTabBar
//
//  Created by 임국성 on 30/07/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

extension Auth {
    // Mark: - Auth Create Mentor
    func createMentor(withEmail email: String, username: String, nickname: String, password: String, profileImage: UIImage?, completion: @escaping (Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, err) in
            if let err = err {
                print("Failed to create user:", err)
                completion(err)
                return
            }
            guard let uid = user?.user.uid else { return }
            if let profileImage = profileImage {
                Storage.storage().uploadUserProfileImage(profileImage: profileImage, completion: { (profileImageUrl) in
                    self.uploadMentor(withUID: uid, username: username, nickname: nickname, profileImageUrl: profileImageUrl) {
                        completion(nil)
                    }
                })
            } else {
                self.uploadMentor(withUID: uid, username: username, nickname: nickname) {
                    completion(nil)
                }
            }
        })
    }
    private func uploadMentor(withUID uid: String, username: String, nickname: String?, profileImageUrl: String? = nil, completion: @escaping (() -> ())) {
        var dictionaryValues = ["username": username]
        if nickname != nil {
            dictionaryValues["nickname"] = nickname
        }
        if profileImageUrl != nil {
            dictionaryValues["profileImageUrl"] = profileImageUrl
        }
        
        let values = [uid: dictionaryValues]
        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to upload user to database:", err)
                return
            }
            completion()
        })
    }
    
    // Mark: - Auth Create Mentee
    func createMentee(withEmail email:String, username: String, nickname: String, password: String, profileImage: UIImage?, completion: @escaping (Error?) -> () ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, err) in
            if let err = err {
                print("Failed to create Mentee:", err)
                completion(err)
                return
            }
            guard let uid = user?.user.uid else {return}
            if let profileImage = profileImage {
            Storage.storage().uploadUserProfileImage(profileImage: profileImage, completion: { (profileImageUrl) in
                self.uploadMentee(withUID: uid, username: username, nickname: nickname, profileImageUrl: profileImageUrl) {
                        completion(nil)
                    }
                })
            } else {
                self.uploadMentee(withUID: uid, username: username, nickname: nickname) {
                    completion(nil)
                }
            }
        })

    }
    private func uploadMentee(withUID uid: String, username: String, nickname: String?, profileImageUrl: String? = nil, completion: @escaping (() -> ())) {
        var dictionaryValues = ["username": username]
        if nickname != nil {
            dictionaryValues["nickname"] = nickname
        }
        if profileImageUrl != nil {
            dictionaryValues["profileImageUrl"] = profileImageUrl
        }
        
        let values = [uid: dictionaryValues]
        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to upload user to database:", err)
                return
            }
            completion()
        })
        
    }
    
}


extension Storage {
    // Mark: - Custom FireBase Storage with Mentor SignUp
    fileprivate func uploadUserProfileImage(profileImage: UIImage, completion: @escaping (String) -> ()) {
        guard let uploadData = profileImage.jpegData(compressionQuality: 1) else { return } //changed from 0.3
        
        let storageRef = Storage.storage().reference().child("profile_images").child(NSUUID().uuidString)
        
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload profile image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for profile image:", err)
                    return
                }
                guard let profileImageUrl = downloadURL?.absoluteString else { return }
                completion(profileImageUrl)
            })
        })
    }
    
    func uploadUserMediaImage(mediaImage: UIImage, completion: @escaping (String) -> ()) {
        guard let uploadData = mediaImage.jpegData(compressionQuality: 1) else { return } //changed from 0.3
        
        let storageRef = Storage.storage().reference().child("media_Images").child(NSUUID().uuidString)
        
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload media image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for media image:", err)
                    return
                }
                guard let mediaImageUrl = downloadURL?.absoluteString else { return }
                completion(mediaImageUrl)
            })
        })
    }
    
    func uploadUserLicenseImage(licenseImage: UIImage, completion: @escaping (String) -> ()) {
        guard let uploadData = licenseImage.jpegData(compressionQuality: 1) else { return } //changed from 0.3
        
        let storageRef = Storage.storage().reference().child("license_Images").child(NSUUID().uuidString)
        
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload license image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for license image:", err)
                    return
                }
                guard let licenseImageUrl = downloadURL?.absoluteString else { return }
                completion(licenseImageUrl)
            })
        })
    }
}

