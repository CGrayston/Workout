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
    
    // MARK: - Landing Pad
    //var programUID: String?
    
    // Source of truth
    static let shared = WorkoutController()
    
    
    // MARK: - Initilize
    init() {
        db = Firestore.firestore()
    }
    
    
    // MARK: - CRUD Functions
    
    // Create Program
    func createWorkout(programUID: String, completion: @escaping (Bool, Workout?) -> Void) {
        
        // Create an empty Program locally
        let workout = Workout(programUID: programUID, name: "", description: "")
        self.workouts.append(workout)
        
        // Create a Program on Firestore
        db.collection(DatabaseReference.workoutDatabase).document(workout.uid).setData([
            "programUID": programUID,
            "name": "",
            "description": "",
            "uid": workout.uid
        ]) { err in
            if let err = err {
                print("Error writing workout: \(err)")
                completion(false, nil)
                return
            } else {
                print("Workout successfully created!")
                completion(true, workout)
                return
            }
        }
    }
    
    // Update Program
    func updateWorkout(workout: Workout, name: String, description: String, completion: @escaping (Bool) -> Void) {
        // Update Program locally
        guard let index = workouts.index(of: workout) else {
                completion(false)
                return
        }
        workouts[index].name = name
        workouts[index].description = description
        
        // Update Program on Firestore
        db.collection(DatabaseReference.workoutDatabase).document(workout.uid).setData([
            "programUID": workout.programUID,
            "name": name,
            "description": description,
            "uid": workout.uid
        ]) { err in
            if let err = err {
                print("Error updating workout: \(err)")
                completion(false)
                return
            } else {
                print("Workout successfully updated!")
                completion(true)
                return
            }
        }
    }
    
    // Delete Program
    func deleteWorkout(workout: Workout, completion: @escaping (Bool) -> Void) {
        // Delete locally
        guard let index = self.workouts.index(of: workout) else { return }
        self.workouts.remove(at: index)
        
        // Delete from Firestore
        db.collection(DatabaseReference.workoutDatabase).document(workout.uid).delete() { err in
            if let err = err {
                print("Error removing workout: \(err)")
                completion(false)
            } else {
                print("Workout successfully removed!")
                completion(true)
            }
        }
    }
    
    // MARK: - Load workouts for currentUsers specified Program
    func loadWorkouts(programUID: String, completion: @escaping () -> ()) {
        
        
        db.collection(DatabaseReference.workoutDatabase).whereField("programUID", isEqualTo: programUID)
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
