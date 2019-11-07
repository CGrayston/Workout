//
//  ExerciseController.swift
//  Workout
//
//  Created by Chris Grayston on 4/5/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import Firebase

class ExerciseController {
    // MARK: - Properties
    var exercises: [Exercise] = []
    
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
    
    // MARK: - Landing Pad
    //var programUID: String?
    
    // Source of truth
    static let shared = ExerciseController()
    
    
    // MARK: - Initilize
    init() {
        db = Firestore.firestore()
    }
    
    
    // MARK: - CRUD Functions
    
    // Create Exercise
    func createExercise(workoutUID: String, completion: @escaping (Bool, Exercise?) -> Void) {
        
        // Create an empty Program locally
        let exercise = Exercise(workoutUID: workoutUID, name: "", description: "", sets: "", reps: "", photoURL: "")
        self.exercises.append(exercise)
        
        // Create a Program on Firestore
        db.collection(DatabaseReference.exerciseDatabase).document(exercise.uid).setData([
            "workoutUID": workoutUID,
            "name": "",
            "description": "",
            "sets": "",
            "setsCount": 0,
            "reps": "",
            "photoURL": "",
            "uid": exercise.uid
        ]) { err in
            if let err = err {
                print("Error writing exercise: \(err)")
                completion(false, nil)
                return
            } else {
                print("Exercise successfully created!")
                completion(true, exercise)
                return
            }
        }
    }
    
    // Update Exercise
    func updateExercise(exercise: Exercise, name: String, description: String, sets: String, setsCount: Int, reps: String, photoURL: String, completion: @escaping (Bool) -> Void) {
        // Update Program locally
        guard let index = exercises.firstIndex(of: exercise) else {
            completion(false)
            return
        }
        exercises[index].name = name
        exercises[index].description = description
        exercises[index].sets = sets
        exercises[index].setsCount = setsCount
        exercises[index].reps = reps
        exercises[index].photoURL = photoURL
        
        // Update Exercise on Firestore
        db.collection(DatabaseReference.exerciseDatabase).document(exercise.uid).setData([
            "workoutUID": exercise.workoutUID,
            "name": name,
            "description": description,
            "sets": sets,
            "setsCount": setsCount,
            "reps": reps,
            "photoURL": photoURL,
            "uid": exercise.uid
        ]) { err in
            if let err = err {
                print("Error updating exercise: \(err)")
                completion(false)
                return
            } else {
                print("Exercise successfully updated!")
                completion(true)
                return
            }
        }
    }
    
    // Update exercise isCompletedValue
    func exerciseIsCompleted(exercise: Exercise) {
        exercise.isCompleted = true
    }
    
    // Delete Program
    func deleteExercise(exercise: Exercise, completion: @escaping (Bool) -> Void) {
        // Delete locally
        guard let index = self.exercises.firstIndex(of: exercise) else { return }
        self.exercises.remove(at: index)
        
        // Delete from Firestore
        db.collection(DatabaseReference.exerciseDatabase).document(exercise.uid).delete() { err in
            if let err = err {
                print("Error removing exercise: \(err)")
                completion(false)
            } else {
                print("Exercise successfully removed!")
                completion(true)
            }
        }
    }
    
    // MARK: - Load exercises for currentUsers specified Program
    func loadExercises(workoutUID: String, completion: @escaping () -> ()) {
        
        
        db.collection(DatabaseReference.exerciseDatabase).whereField("workoutUID", isEqualTo: workoutUID)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error loading exercise: \(error.localizedDescription)")
                    return completion()
                }
                self.exercises = []
                
                // Found querySnapshot!.documents.count documents in the Program snapshot
                for document in querySnapshot!.documents {
                    guard let exercise = Exercise(document: document) else {
                        completion()
                        return
                    }
                    self.exercises.append(exercise)
                }
                completion()
        }
    }
    
    // MARK: - Fetch
    
    // MARK: - Fetch Exercises for Selected Workout
    func getExercisesForWorkout(_ workout: Workout, completion: @escaping ([Exercise]) -> (Void)) {
        var exercises: [Exercise] = []
        // Search for all workouts associated with given Program
        let query = db.collection(DatabaseReference.exerciseDatabase).whereField("workoutUID", isEqualTo: workout.uid)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting exercises from Firestore: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let querySnapshot = querySnapshot else { return }
            for document in querySnapshot.documents {
                guard let exercise = Exercise(document: document) else { return }
                exercises.append(exercise)
            }
            completion(exercises)
        }
    }
}

