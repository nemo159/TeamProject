//
//  Users.swift
//  portfolioTabBar
//
//  Created by 임국성 on 23/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
//    let username: String
//    let profileImageUrl: String?
    let nickname: String?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
//        self.username = dictionary["username"] as? String ?? ""
//        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? nil
        self.nickname = dictionary["nickname"] as? String ?? nil
    }
}
