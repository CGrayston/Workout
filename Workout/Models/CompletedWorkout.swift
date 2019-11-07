//
//  CompletedWorkout.swift
//  Workout
//
//  Created by Chris Grayston on 4/10/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit
import Firebase

class CompletedWorkout {
    // MARK: - Properties
    let userUID: String
    let programUID: String
    var programName: String
    var name: String
    var description: String
    var dateCompleted: Date
    let uid: String
    
    // MARK: - Memberwise initilizer
    init(userUID: String, program: Program, name: String, description: String, dateCompleted: Date = Date(), uid: String = UUID.init().uuidString) {
        self.userUID = userUID
        self.programUID = program.uid
        self.programName = program.name
        self.name = name
        self.description = description
        self.dateCompleted = dateCompleted
        self.uid = uid
    }
    
    // MARK: - Failable initilizer
    init?(document: QueryDocumentSnapshot) {
        guard let userUID = document["userUID"] as? String,
            let programUID = document["programUID"] as? String,
            let programName = document["programName"] as? String,
            let name = document["name"] as? String,
            let description = document["description"] as? String,
            let dateCompleted = document["dateCompleted"] as? Timestamp,
            let uid = document["uid"] as? String
            else { return nil }
        
        
        self.userUID = userUID
        self.programUID = programUID
        self.programName = programName
        self.name = name
        self.description = description
        self.dateCompleted = dateCompleted.dateValue()
        self.uid = uid
    }
}

extension CompletedWorkout: Equatable {
    static func == (lhs: CompletedWorkout, rhs: CompletedWorkout) -> Bool {
        return lhs.uid == rhs.uid
    }
}



