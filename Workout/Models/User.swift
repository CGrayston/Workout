//
//  User.swift
//  Workout
//
//  Created by Chris Grayston on 4/5/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation

class User {
    var email: String
    var username: String
    var uid: String
    
    init(email: String, username: String, uid: String) {
        self.email = email
        self.username = username
        self.uid = uid
    }
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let username = dictionary["username"] as! String? ?? ""
        let uid = dictionary["uid"] as! String? ?? ""
        
        self.init(email: email, username: username, uid: uid)
    }
}
