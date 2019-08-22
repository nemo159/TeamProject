//
//  MenteeUser.swift
//  portfolioTabBar
//
//  Created by 임국성 on 01/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import Foundation

struct MenteeUser{
    let uid: String
    let username: String
    let phoneNumber: String
    let who: String
    
    init(uid: String, dictionary: [String: Any], who: String) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.phoneNumber = dictionary["phoneNumber"] as! String
        self.who = "Mentee User"
    }
}
