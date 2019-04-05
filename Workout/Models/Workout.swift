//
//  Workout.swift
//  Workout
//
//  Created by Chris Grayston on 4/4/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import Firebase

class Workout {
    // MARK: - Properties
    let programUID: String
    var name: String
    var description: String
    let uid: String
    
    // MARK: - Memberwise initilizer
    init(programUID: String, name: String, description: String, uid: String = UUID.init().uuidString) {
        self.programUID = programUID
        self.name = name
        self.description = description
        self.uid = uid
    }
    
    // MARK: - Failable initilizer
    init?(document: QueryDocumentSnapshot) {
        guard let programUID = document["programUID"] as? String,
            let name = document["name"] as? String,
            let description = document["description"] as? String,
            let uid = document["uid"] as? String
            else { return nil }
        
        self.programUID = programUID
        self.name = name
        self.description = description
        self.uid = uid
    }
}

extension Workout: Equatable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.uid == rhs.uid
    }
}


