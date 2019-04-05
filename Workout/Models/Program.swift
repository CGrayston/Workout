//
//  Program.swift
//  Workout
//
//  Created by Chris Grayston on 4/4/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import Firebase

class Program {
    // MARK: - Properties
    let creatorUID: String
    var name: String
    var description: String
    var photoURL: String
    let uid: String
    
    // MARK: - Memberwise initilizer
    init(creatorUID: String, name: String, description: String, photoURL: String, uid: String = UUID.init().uuidString) {
        self.creatorUID = creatorUID
        self.name = name
        self.description = description
        self.photoURL = photoURL
        self.uid = uid
    }
    
    // MARK: - Failable initilizer
    convenience init(document: [String: Any]) {
        let creatorUID = document["creatorUID"] as! String? ?? ""
        let name = document["name"] as! String? ?? ""
        let description = document["description"] as! String? ?? ""
        let photoURL = document["photoURL"] as! String? ?? ""
        let uid = document["uid"] as! String? ?? ""
        
        self.init(creatorUID: creatorUID, name: name, description: description, photoURL: photoURL, uid: uid)
    }
}

extension Program: Equatable {
    static func == (lhs: Program, rhs: Program) -> Bool {
        return lhs.uid == rhs.uid
    }
}
