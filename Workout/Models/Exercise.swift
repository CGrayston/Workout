//
//  Exercise.swift
//  Workout
//
//  Created by Chris Grayston on 4/4/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import Firebase

class Exercise {
    // MARK: - Properties
    let workoutUID: String
    var name: String
    var description: String
    var sets: String
    var setsCount: Int
    var reps: String
    var photoURL: String
    let uid: String
    
    // MARK: - Memberwise initilizer
    init(workoutUID: String, name: String, description: String, sets: String, setsCount: Int = 0, reps: String, photoURL: String, uid: String = UUID.init().uuidString) {
        self.workoutUID = workoutUID
        self.name = name
        self.description = description
        self.sets = sets
        self.setsCount = setsCount
        self.reps = reps
        self.photoURL = photoURL
        self.uid = uid
    }
    
    // MARK: - Failable initilizer
    init?(document: QueryDocumentSnapshot) {
        guard let workoutUID = document["workoutUID"] as? String,
            let name = document["name"] as? String,
            let description = document["description"] as? String,
            let sets = document["sets"] as? String,
            let setsCount = document["setsCount"] as? Int,
            let reps = document["reps"] as? String,
            let photoURL = document["photoURL"] as? String,
            let uid = document["uid"] as? String
            else { return nil }
        
        self.workoutUID = workoutUID
        self.name = name
        self.description = description
        self.sets = sets
        self.setsCount = setsCount
        self.reps = reps
        self.photoURL = photoURL
        self.uid = uid
    }
}

extension Exercise: Equatable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.uid == rhs.uid
    }
}



