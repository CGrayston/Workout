//
//  CompletedExerciseController.swift
//  Workout
//
//  Created by Chris Grayston on 4/11/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import Firebase

class CompletedExerciseController {
    // MARK: - Properties
    var completedExercises: [CompletedExercise] = []
    
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
    static let shared = CompletedExerciseController()
    
    
    // MARK: - Initilize
    init() {
        db = Firestore.firestore()
    }
    
    
    // MARK: - CRUD Functions
    
    // Create Exercise
    func saveCompletedExerciseToFirestore(completedExercise: CompletedExercise, completion: @escaping (Bool) -> Void) {
        
        // Create an empty Program locally
        //let completedExercise = CompletedExercise(exercise: exercise, completedWorkout: completedWorkout)
        //self.completedExercises.append(completedExercise)
        
        // Create a Program on Firestore
        db.collection(DatabaseReference.completedExerciseDatabase).document(completedExercise.uid).setData([
            "completedWorkoutUID": completedExercise.completedWorkoutUID,
            "exerciseUID": completedExercise.exerciseUID,
            "name": completedExercise.name,
            "description": completedExercise.description,
            "sets": completedExercise.sets,
            "setsCount": completedExercise.setsCount,
            "reps": completedExercise.reps,
            "photoURL": completedExercise.photoURL,
            "uid": completedExercise.uid,
            "weightsCompleted": completedExercise.weightsCompleted,
            "repsCompleted": completedExercise.repsCompleted,
            "dateCompleted": completedExercise.dateCompleted,
            "isCompleted": completedExercise.isCompleted
        ]) { err in
            if let err = err {
                print("Error writing completed exercise: \(err)")
                completion(false)
                return
            } else {
                print("Completed Exercise successfully created!")
                completion(true)
                return
            }
        }
    }
    
    // Update Exercise
    func updateExerciseWeightAndRepsValuesLocally(completedExercise: CompletedExercise, weightsCompleted: [Double], repsCompleted: [Int]) {
        // Update completedExercises weights and reps Completed values
        // TODO - Beleieve this is the right way to do this
        completedExercise.weightsCompleted = weightsCompleted
        completedExercise.repsCompleted = repsCompleted
        
        // Change to isCompelted = true
        completedExercise.isCompleted = true
    }
    
    
//    func updateExercise(exercise: Exercise, name: String, description: String, sets: String, setsCount: Int, reps: String, photoURL: String, completion: @escaping (Bool) -> Void) {
//        // Update Program locally
//        guard let index = exercises.index(of: exercise) else {
//            completion(false)
//            return
//        }
//        exercises[index].name = name
//        exercises[index].description = description
//        exercises[index].sets = sets
//        exercises[index].setsCount = setsCount
//        exercises[index].reps = reps
//        exercises[index].photoURL = photoURL
//
//        // Update Exercise on Firestore
//        db.collection(DatabaseReference.exerciseDatabase).document(exercise.uid).setData([
//            "workoutUID": exercise.workoutUID,
//            "name": name,
//            "description": description,
//            "sets": sets,
//            "setsCount": setsCount,
//            "reps": reps,
//            "photoURL": photoURL,
//            "uid": exercise.uid
//        ]) { err in
//            if let err = err {
//                print("Error updating exercise: \(err)")
//                completion(false)
//                return
//            } else {
//                print("Exercise successfully updated!")
//                completion(true)
//                return
//            }
//        }
//    }
    
    // Update exercise isCompletedValue
    func exerciseIsCompleted(completedExercise: CompletedExercise) {
        completedExercise.isCompleted = true
        
        // TODO update in firestore?
        
    }
    
    // Delete Program
//    func deleteExercise(exercise: Exercise, completion: @escaping (Bool) -> Void) {
//        // Delete locally
//        guard let index = self.exercises.index(of: exercise) else { return }
//        self.exercises.remove(at: index)
//        
//        // Delete from Firestore
//        db.collection(DatabaseReference.exerciseDatabase).document(exercise.uid).delete() { err in
//            if let err = err {
//                print("Error removing exercise: \(err)")
//                completion(false)
//            } else {
//                print("Exercise successfully removed!")
//                completion(true)
//            }
//        }
//    }
    
    // MARK: - Load exercises for currentUsers specified Program
//    func loadExercises(workoutUID: String, completion: @escaping () -> ()) {
//
//
//        db.collection(DatabaseReference.exerciseDatabase).whereField("workoutUID", isEqualTo: workoutUID)
//            .addSnapshotListener { (querySnapshot, error) in
//                if let error = error {
//                    print("Error loading exercise: \(error.localizedDescription)")
//                    return completion()
//                }
//                self.exercises = []
//
//                // Found querySnapshot!.documents.count documents in the Program snapshot
//                for document in querySnapshot!.documents {
//                    guard let exercise = Exercise(document: document) else {
//                        completion()
//                        return
//                    }
//                    self.exercises.append(exercise)
//                }
//                completion()
//        }
//    }
    
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
    
    /*
     * Creates local initilized completedExercises that will be saved later if User presses save on WorkoutVC
     */
    func createInitialCompletedExercisesFromWorkout(_ workout: Workout, completedWorkout: CompletedWorkout, completion: @escaping (Bool) -> (Void)) {
        var completedExercises: [CompletedExercise] = []
        // Search for all workouts associated with given Program
        let query = db.collection(DatabaseReference.exerciseDatabase).whereField("workoutUID", isEqualTo: workout.uid)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting exercises from Firestore to make completedExercises: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // get exercises from query to make into initial completedExercises
            guard let querySnapshot = querySnapshot else { return }
            for document in querySnapshot.documents {
                guard let completedExercise = CompletedExercise(completedWorkout: completedWorkout, document: document) else { return }
                completedExercises.append(completedExercise)
                
//                guard let completedExercise = CompletedExercise(completedWorkout: completedWorkout, document: document) else { return }
//                completedExercises.append(completedExercise)
            }
            // return
            self.completedExercises = completedExercises
            
            // TODO - maybe get rid of returning this
            //completion(completedExercises)
            completion(true)
        }
    }
    
    // MARK: - Fetch
    func getCompletedExercises(for completedWorkout: CompletedWorkout, completion: @escaping ([CompletedExercise]) -> Void) {
        var completedExercises: [CompletedExercise] = []
        
        let query = db.collection(DatabaseReference.completedExerciseDatabase).whereField("completedWorkoutUID", isEqualTo: completedWorkout.uid)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting workouts from Firestore: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let querySnapshot = querySnapshot else { return }
            for document in querySnapshot.documents {
                guard let completedExercise = CompletedExercise(document: document) else { return }
                completedExercises.append(completedExercise)
            }
            completion(completedExercises)
        }
    }
    
    func fetchExerciseHistory(with compeltedExercise: CompletedExercise, completion: @escaping ([CompletedExercise]) -> (Void)) {
        var completedExercises: [CompletedExercise] = []
        
        let query = db.collection(DatabaseReference.completedExerciseDatabase).whereField("exerciseUID", isEqualTo: compeltedExercise.exerciseUID)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting workouts from Firestore: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let querySnapshot = querySnapshot else { return }
            for document in querySnapshot.documents {
                
                guard let completedExercise = CompletedExercise(document: document) else { return }
                completedExercises.append(completedExercise)
            }
            completion(completedExercises)
        }
    }
}

