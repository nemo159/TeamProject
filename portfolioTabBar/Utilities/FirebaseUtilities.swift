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

extension Database {
    
    //MARK: Users
    func fetchUser(withUID uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (err) in
            print("Failed to fetch user from database:", err)
        }
    }
    
    func fetchAllUsers(includeCurrentUser: Bool = true, completion: @escaping ([User]) -> (), withCancel cancel: ((Error) -> ())?) {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var users = [User]()
            
            dictionaries.forEach({ (key, value) in
                if !includeCurrentUser, key == Auth.auth().currentUser?.uid {
                    completion([])
                    return
                }
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                users.append(user)
            })
            
//            users.sort(by: { (user1, user2) -> Bool in
//                return user1.username.compare(user2.username) == .orderedAscending
//            })
            completion(users)
            
        }) { (err) in
            print("Failed to fetch all users from database:", (err))
            cancel?(err)
        }
    }
    
    //MARK: Posts
//    func createPost(withImage image: UIImage, caption: String, completion: @escaping (Error?) -> ()) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        let userPostRef = Database.database().reference().child("posts").child(uid).childByAutoId()
//
//        guard let postId = userPostRef.key else { return }
//
//        Storage.storage().uploadPostImage(image: image, filename: postId) { (postImageUrl) in
//            let values = ["imageUrl": postImageUrl, "caption": caption, "imageWidth": image.size.width, "imageHeight": image.size.height, "creationDate": Date().timeIntervalSince1970, "id": postId] as [String : Any]
//
//            userPostRef.updateChildValues(values) { (err, ref) in
//                if let err = err {
//                    print("Failed to save post to database", err)
//                    completion(err)
//                    return
//                }
//                completion(nil)
//            }
//        }
//    }
    
    //MARK: Messages
    func addMessageToFollow(uid: String, withFollowId followID: String, text: String, completion: @escaping (Error?) -> ()) {
        let reference = Database.database().reference().child("messages")
        let childRef = reference.childByAutoId()
        
        let values = ["text": text, "creationDate": Date().timeIntervalSince1970, "toUid": followID, "fromUid": uid] as [String: Any]
        
        childRef.updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to add message:", err)
                completion(err)
                return
            }
            completion(nil)
        }
        guard let messageID = childRef.key else { return }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(followID).child(messageID)
        userMessagesRef.setValue(1)
        
        let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(followID).child(uid).child(messageID)
        recipientUserMessagesRef.setValue(1)
        
    }
    
    //
    //    func fetchMessageFromFollow(withId followID: String, completion: @escaping ([Message]) -> (), withCancel cancel: ((Error) -> ())?) {
    //        guard let uid = Auth.auth().currentUser?.uid else {return}
    //        let messagesRef = Database.database().reference().child("messages").child(uid).child("sR9NTPPeCBTbnGvBUT7X4QLeoOo1")
    //        messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
    //            print("1.. \(snapshot)")
    //            guard let dictionaries = snapshot.value as? [String: Any] else {
    //                completion([])
    //                return
    //            }
    //            var messages = [Message]()
    //
    //            dictionaries.forEach({ (key, value) in
    //                guard let messageDictionary = value as? [String: Any] else { return }
    //                guard let uid = messageDictionary["uid"] as? String else { return }
    ////                print("2.. \(messageDictionary)")
    ////                print("3.. \(uid)")
    //                Database.database().fetchUser(withUID: uid) { (user) in
    //                    let message = Message(user: user, dictionary: messageDictionary)
    //                    messages.append(message)
    //
    //                    if messages.count == dictionaries.count {
    //                        messages.sort(by: { (message1, message2) -> Bool in
    //                            return message1.creationDate.compare(message2.creationDate) == .orderedAscending
    //                        })
    //                        completion(messages)
    //                    }
    //                }
    //            })
    //
    //        }) { (err) in
    //            print("Failed to fetch messages:", err)
    //            cancel?(err)
    //        }
    //    }
    //
    //
    
}
