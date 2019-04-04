//
//  Program.swift
//  Workout
//
//  Created by Chris Grayston on 4/4/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation

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
}
