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
    var followedPrograms: [String]
    var createdPrograms: [String]
    var uid: String
    
    init(email: String, username: String, followedPrograms: [String] = [], createdPrograms: [String] = [], uid: String) {
        self.email = email
        self.username = username
        self.followedPrograms = followedPrograms
        self.createdPrograms = createdPrograms
        self.uid = uid
    }
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let username = dictionary["username"] as! String? ?? ""
        let followedPrograms = dictionary["followedPrograms"] as! [String]? ?? []
        let createdPrograms = dictionary["createdPrograms"] as! [String]? ?? []
        let uid = dictionary["uid"] as! String? ?? ""
        
        self.init(email: email, username: username, followedPrograms: followedPrograms, createdPrograms: createdPrograms, uid: uid)
    }
}
