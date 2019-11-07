//
//  CompletedExercise.swift
//  Workout
//
//  Created by Chris Grayston on 4/11/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import Firebase

class CompletedExercise {
    // MARK: - Properties
    
    let completedWorkoutUID: String
    let exerciseUID: String
    
    // get this information from an exercise
    var name: String
    var description: String
    var photoURL: String
    var sets: String
    var setsCount: Int
    var reps: String
    
    // Hold what weight and reps the user did
    var weightsCompleted: [Double]
    var repsCompleted: [Int]
    
    // Date and time workout was saved
    var dateCompleted: Date
    
    var isCompleted: Bool
    let userUID: String
    let uid: String
    
    // MARK: - Memberwise initilizer - Made when we navigate to the WorkoutVC
    init(exercise: Exercise, completedWorkout: CompletedWorkout, weightsCompleted: [Double] = [], repsCompleted: [Int] = [], isCompleted: Bool = false, uid: String = UUID.init().uuidString) {
        self.completedWorkoutUID = completedWorkout.uid
        self.exerciseUID = exercise.uid
        self.name = exercise.name
        self.description = exercise.description
        self.photoURL = exercise.photoURL
        self.sets = exercise.sets
        self.setsCount = exercise.setsCount
        self.reps = exercise.reps
        
        self.weightsCompleted = weightsCompleted
        self.repsCompleted = repsCompleted
        
        self.dateCompleted = completedWorkout.dateCompleted
        
        self.isCompleted = isCompleted
        self.userUID = completedWorkout.userUID
        self.uid = uid
        
        
    }

    // MARK: - Failable initilizer for empty CompletedExercise
    init?(completedWorkout: CompletedWorkout, document: QueryDocumentSnapshot) {
        guard let name = document["name"] as? String,
            let exerciseUID = document["uid"] as? String,
            let description = document["description"] as? String,
            let sets = document["sets"] as? String,
            let setsCount = document["setsCount"] as? Int,
            let reps = document["reps"] as? String,
            let photoURL = document["photoURL"] as? String
            else { return nil }
        
        // Set stuff
        self.completedWorkoutUID = completedWorkout.uid
        self.exerciseUID = exerciseUID
        self.name = name
        self.description = description
        self.photoURL = photoURL
        self.sets = sets
        self.setsCount = setsCount
        self.reps = reps
        
        self.weightsCompleted = []
        self.repsCompleted = []
        
        self.dateCompleted = completedWorkout.dateCompleted
        
        self.isCompleted = false
        self.userUID = completedWorkout.userUID
        self.uid = UUID.init().uuidString
    }



    // MARK: - Failable initilizer
    init?(document: QueryDocumentSnapshot) {
        guard let completedWorkoutUID = document["completedWorkoutUID"] as? String,
            let name = document["name"] as? String,
            let exerciseUID = document["exerciseUID"] as? String,
            let description = document["description"] as? String,
            let sets = document["sets"] as? String,
            let setsCount = document["setsCount"] as? Int,
            let reps = document["reps"] as? String,
            let photoURL = document["photoURL"] as? String,
            let weightsCompleted = document["weightsCompleted"] as? [Double],
            let repsCompleted = document["repsCompleted"] as? [Int],
            let dateCompleted = document["dateCompleted"] as? Timestamp,
            let isCompleted = document["isCompleted"] as? Bool,
            let userUID = document["userUID"] as? String,
            let uid = document["uid"] as? String
            else { return nil }
        
        self.completedWorkoutUID = completedWorkoutUID
        self.exerciseUID = exerciseUID
        self.name = name
        self.description = description
        self.photoURL = photoURL
        self.sets = sets
        self.setsCount = setsCount
        self.reps = reps
        
        self.weightsCompleted = weightsCompleted
        self.repsCompleted = repsCompleted
        
        self.dateCompleted = dateCompleted.dateValue()
        
        self.isCompleted = isCompleted
        self.userUID = userUID
        self.uid = uid
    }
}

extension CompletedExercise: Equatable {
    static func == (lhs: CompletedExercise, rhs: CompletedExercise) -> Bool {
        return lhs.uid == rhs.uid
    }
}
