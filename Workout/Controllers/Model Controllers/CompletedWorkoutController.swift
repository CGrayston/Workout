//
//  CompletedWorkoutController.swift
//  Workout
//
//  Created by Chris Grayston on 4/10/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit
import Firebase

class CompletedWorkoutController {
    // MARK: - Properties
    var completedWorkouts: [CompletedWorkout] = []
    
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
    static let shared = CompletedWorkoutController()
    
    
    // MARK: - Initilize
    init() {
        db = Firestore.firestore()
    }
    
    
    // MARK: - CRUD Functions
    
    // Create Program
    func createCompletedWorkout(program: Program, workout: Workout, completion: @escaping (Bool) -> Void) {
        
        // Create an empty Program locally
        let completedWorkout = CompletedWorkout(userUID: userUID, program: program, name: workout.name, description: workout.description)
        self.completedWorkouts.append(completedWorkout)
        
        // Create a CompletedProgram on Firestore
        db.collection(DatabaseReference.completedWorkoutDatabase).document(completedWorkout.uid).setData([
            "userUID": userUID,
            "programUID": program.uid,
            "programName": program.name,
            "name": workout.name,
            "description": workout.description,
            "dateCompleted": completedWorkout.dateCompleted,
            "uid": workout.uid
        ]) { err in
            if let err = err {
                print("Error writing completedworkout: \(err)")
                completion(false)
                return
            } else {
                print("Completed Workout successfully created!")
                completion(true)
                return
            }
        }
    }
    
    func saveCompletedWorkoutAndExercisesToFirestore(completedWorkout: CompletedWorkout, completion: @escaping (Bool) -> Void) {
        // Create an empty Program locally TODO - Don't think need to update it locally
        
        
        // Create a CompletedProgram on Firestore
        db.collection(DatabaseReference.completedWorkoutDatabase).document(completedWorkout.uid).setData([
            "userUID": userUID,
            "programUID": completedWorkout.programUID,
            "programName": completedWorkout.programName,
            "name": completedWorkout.name,
            "description": completedWorkout.description,
            "dateCompleted": completedWorkout.dateCompleted,
            "uid": completedWorkout.uid
        ]) { err in
            if let err = err {
                print("Error writing completed workout: \(err)")
                completion(false)
                return
            } else {
                print("Completed Workout successfully created!")
                completion(true)
                //CompletedExerciseController.shared.createCompletedExercise(completedExercise: <#T##CompletedExercise#>, completion: <#T##(Bool) -> Void#>)
                // Save completedExercises to Firestore
                //CompletedExerciseController.shared.saveCompletedExercisesToFirestore
                
                return
            }
        }
    }
    
//    func createInitialCompletedWorkout(program: Program, workout: Workout, completion: @escaping (CompletedWorkout) -> Void) {
//        // Create an empty Program locally
//        let completedWorkout = CompletedWorkout(userUID: userUID, program: program, name: workout.name, description: workout.description)
//        //self.completedWorkouts.append(completedWorkout)
//
//
//    }
    
    func createInitialCompletedWorkout(program: Program, workout: Workout) -> CompletedWorkout {
        // Create an empty Program locally
        let completedWorkout = CompletedWorkout(userUID: userUID, program: program, name: workout.name, description: workout.description)
        return completedWorkout
        //self.completedWorkouts.append(completedWorkout)
        
        
    }

    
//    // Update Program
//    func updateWorkout(workout: Workout, name: String, description: String, completion: @escaping (Bool) -> Void) {
//        // Update Program locally
//        guard let index = workouts.index(of: workout) else {
//            completion(false)
//            return
//        }
//        workouts[index].name = name
//        workouts[index].description = description
//
//        // Update Program on Firestore
//        db.collection(DatabaseReference.workoutDatabase).document(workout.uid).setData([
//            "programUID": workout.programUID,
//            "name": name,
//            "description": description,
//            "uid": workout.uid
//        ]) { err in
//            if let err = err {
//                print("Error updating workout: \(err)")
//                completion(false)
//                return
//            } else {
//                print("Workout successfully updated!")
//                completion(true)
//                return
//            }
//        }
//    }
    
    // Delete Program
    func deleteCompletedWorkout(completedWorkout: CompletedWorkout, completion: @escaping (Bool) -> Void) {
        // Delete locally
        guard let index = self.completedWorkouts.firstIndex(of: completedWorkout) else { return }
        self.completedWorkouts.remove(at: index)
        
        // Delete workout from Firestore
        db.collection(DatabaseReference.completedWorkoutDatabase).document(completedWorkout.uid).delete() { err in
            if let err = err {
                print("Error removing completed workout: \(err)")
                completion(false)
            } else {
                print("Completed Workout successfully removed!")
                
                // TODO remove completed exercises associated
                self.deleteAllExercisesFromWorkout(completedWorkoutUID: completedWorkout.uid, completion: {
                    completion(true)
                })
            }
        }
        
        // Delete all exercises contained in workout
        
    }
    // TODO
    private func deleteAllExercisesFromWorkout(completedWorkoutUID: String, completion: @escaping () -> ()) {
        let dispatchGroup = DispatchGroup()
        
        
        db.collection(DatabaseReference.completedExerciseDatabase).whereField("completedWorkoutUID", isEqualTo: completedWorkoutUID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting compelted exercises to delete: \(error)")
                completion()
            }
            for document in querySnapshot!.documents {
                dispatchGroup.enter()
                document.reference.delete(completion: { (error) in
                    if let error = error {
                        print(error)
                        dispatchGroup.leave()
                    } else {
                        dispatchGroup.leave()
                    }
                })
            }
            dispatchGroup.notify(queue: .main) {
                completion()
            }
        }
    }
    
    // MARK: - Load workouts for currentUsers specified Program
    func loadCompletedWorkouts(completion: @escaping () -> ()) {
        db.collection(DatabaseReference.completedWorkoutDatabase).whereField("userUID", isEqualTo: userUID)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error loading data: \(error.localizedDescription)")
                    return completion()
                }
                self.completedWorkouts = []
                
                // Found querySnapshot!.documents.count documents in the Program snapshot
                for document in querySnapshot!.documents {
                    guard let completedWorkout = CompletedWorkout(document: document) else {
                        completion()
                        return
                    }
                    self.completedWorkouts.append(completedWorkout)
                }
                completion()
        }
    }
    
    // TODO - Do I need this fetch function
    // MARK: - Fetch
//    func getWorkoutsForProgram(_ program: Program, completion: @escaping ([Workout]) -> (Void)) {
//        var workouts: [Workout] = []
//        // Search for all workouts associated with given Program
//        let query = db.collection(DatabaseReference.workoutDatabase).whereField("programUID", isEqualTo: program.uid)
//
//        query.getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting workouts from Firestore: \(error.localizedDescription)")
//                completion([])
//                return
//            }
//
//            guard let querySnapshot = querySnapshot else { return }
//            for document in querySnapshot.documents {
//                guard let workout = Workout(document: document) else { return }
//                workouts.append(workout)
//            }
//            completion(workouts)
//        }
//    }
    
}
