//
//  Mentor.swift
//  portfolioTabBar
//
//  Created by 임국성 on 01/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import Foundation

struct MentorUser{
    let uid: String
    let username: String
    let profileImageUrl: String?
    let phoneNumber: String
    let location: [String]
    let field: [String]
    let dayTime: [String]
    let about: String?
    let mediaImageUrl: [String]?
    let licenseImageUrl: [String]?
    let who: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? nil
        self.phoneNumber = dictionary["phoneNumber"] as! String
        self.location = dictionary["loaction"] as! [String]
        self.field = dictionary["field"] as! [String]
        self.dayTime = dictionary["dayTime"] as! [String]
        self.about = dictionary["about"] as? String ?? nil
        self.mediaImageUrl = dictionary["mediaImageUrl"] as? [String] ?? nil
        self.licenseImageUrl = dictionary["licenseImageUrl"] as? [String] ?? nil
        self.who = "Mentor User"
    }
}
