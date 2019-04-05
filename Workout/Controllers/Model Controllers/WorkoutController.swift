//
//  WorkoutController.swift
//  Workout
//
//  Created by Chris Grayston on 4/4/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import Firebase

class WorkoutController {
    // MARK: - Properties
    var workouts: [Workout] = []
    
    var db: Firestore!
    
    var userUID: String {
        // TODO - better way to do this?
        get {
            guard let userUID = Auth.auth().currentUser?.uid else {
                //fatalError("Error unwrappig currentUser uid")
                return ""
            }
            return userUID
        }
    }
    
    // Source of truth
    static let shared = WorkoutController()
    
    
    // MARK: - Initilize
    init() {
        db = Firestore.firestore()
    }
    
    // MARK: - CRUD Functions
    
    // MARK: - Load workouts for currentUsers specified Program
    func loadWorkouts(completion: @escaping () -> ()) {
        
        db.collection(DatabaseReference.workoutDatabase).whereField("creatorUID", isEqualTo: userUID)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error loading data: \(error.localizedDescription)")
                    return completion()
                }
                self.workouts = []
                
                // Found querySnapshot!.documents.count documents in the Program snapshot
                for document in querySnapshot!.documents {
                    guard let workout = Workout(document: document) else {
                        completion()
                        return
                    }
                    self.workouts.append(workout)
                }
                completion()
        }
    }
}
