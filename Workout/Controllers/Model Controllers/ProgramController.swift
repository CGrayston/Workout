//
//  ProgramController.swift
//  Workout
//
//  Created by Chris Grayston on 4/4/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import Firebase

class ProgramController {
    // MARK: - Properties
    var programs: [Program] = []
    
    // Set from homescreen
    var createdPrograms: [Program] = []
    var followedPrograms: [Program] = []
    
    var db: Firestore!
    var programDBRef: CollectionReference
    var userUID: String {
        // TODO - better way to do this?
        guard let userUID = Auth.auth().currentUser?.uid else {
            return ""
        }
        return userUID
    }
    
    // Source of truth
    static let shared = ProgramController()
    
    
    // MARK: - Initilize
    init() {
        db = Firestore.firestore()
        programDBRef = db.collection(DatabaseReference.programDatabase)
        
    }
    
    // MARK: - CRUD Functions
    
    // Created Program and adds programUID to User model "createdPrograms"
    
    func createProgram(completion: @escaping (Bool, Program?) -> Void) {
        // Create an empty Program locally
        let program = Program(creatorUID: userUID, name: "", description: "", photoURL: "")
        self.programs.append(program)
        
        // Create a Program on Firestore
        db.collection(DatabaseReference.programDatabase).document(program.uid).setData([
            "creatorUID": userUID,
            "name": "",
            "description": "",
            "photoURL": "",
            "followersUIDs": [],
            "uid": program.uid
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                completion(false, nil)
                return
            } else {
                print("Document successfully created!")
//                completion(true, program)
//                return
                
                // Add programUID to User model under "createdPrograms"
                UserController.shared.addCreatedProgramUID(programUID: program.uid) { (success) -> (Void) in
                    if success {
                        print("Added createdProgramUID success")
                        completion(true, program)
                    } else {
                        print("Failed to add createdProgramUID success")
                        completion(false, program)
                    }
                }
            }
        }
    }
    
    // Update Program
    func updateProgram(program: Program, name: String, description: String, photoURL: String, completion: @escaping (Bool) -> Void) {
        // Update Program locally
        guard let index = programs.firstIndex(of: program) else { completion(false) ; return }
        programs[index].name = name
        programs[index].description = description
        programs[index].photoURL = photoURL
        
        // Update Program on Firestore
        db.collection(DatabaseReference.programDatabase).document(program.uid).setData([
            "creatorUID": userUID,
            "name": name,
            "description": description,
            "photoURL": photoURL,
            "followersUIDs": program.followersUIDs,
            "uid": program.uid
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                completion(false)
                return
            } else {
                print("Document successfully updated!")
                completion(true)
                return
            }
        }
    }
    
    func updateProgramPhotoURL(_ photoURL: String, program: Program, completion: @escaping (Bool) -> (Void)) {
        // Update Program locally
        guard let index = programs.firstIndex(of: program) else { completion(false) ; return }
        programs[index].photoURL = photoURL
        
        db.collection(DatabaseReference.programDatabase).document(program.uid).updateData([
            "photoURL": photoURL,
        ]) { (error) in
            if let error = error {
                print("Error writing document: \(error)")
                completion(false)
                return
            } else {
                print("Document successfully updated!")
                completion(true)
                return
            }
        }
    }
    
    /*
     * Delete program. Must delete all workouts and exercises contained in that program.
     * Also remove the programUID from the User models createdPrograms array
     */
    func deleteProgram(program: Program, completion: @escaping (Bool) -> Void) {
        // Delete locally
        guard let index = self.programs.firstIndex(of: program) else { return }
        self.programs.remove(at: index)
        
        // Delete from Firestore
        db.collection(DatabaseReference.programDatabase).document(program.uid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion(false)
            } else {
                // Delete all workouts that stem from that program
                // This will also delete exercises that stem from deleted workouts
                self.deleteProgramsWorkouts(programUID: program.uid) {
                    // Remove from User model array followed programs
                }
                
                UserController.shared.removeCreatedProgramUID(programUID: program.uid, completion: { (success) -> (Void) in
                    if success {
                        completion(true)
                    }
                })

                print("Document successfully removed!")
            }
        }
    }
    
    // MARK: - Helper Method
    private func deleteProgramsWorkouts(programUID: String, completion: @escaping () -> ()) {
        // Delete all workouts that stem from that program
        let dispatchGroup = DispatchGroup()
        var workoutsUIDs: [String] = []
        
        // Go through workout collection
        db.collection(DatabaseReference.workoutDatabase).whereField("programUID", isEqualTo: programUID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting workouts to delete: \(error)")
            }
            
            for document in querySnapshot!.documents {
                dispatchGroup.enter()
                document.reference.delete(completion: { (error) in
                    if let error = error {
                        print(error)
                        dispatchGroup.leave()
                    } else {
                        // Save the workouts UID to use to delete containing exercises later
                        workoutsUIDs.append(document["uid"] as? String ?? "")
                        dispatchGroup.leave()
                    }
                })
                
            }
            dispatchGroup.notify(queue: .main) {
                // Delete exercises from all workouts deleted
                self.deleteAllExercisesFromWorkouts(workoutsUIDs: workoutsUIDs) {
                    completion()
                }
            }
        }
    }
    
    // Deletes all exercises from WorkoutUIDs passed to it
    private func deleteAllExercisesFromWorkouts(workoutsUIDs: [String], completion: @escaping () -> ()) {
        let dispatchGroup = DispatchGroup()
        
        for workoutUID in workoutsUIDs {
            db.collection(DatabaseReference.exerciseDatabase).whereField("workoutUID", isEqualTo: workoutUID).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting exercises to delete: \(error)")
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
    }
    
    // MARK: - Follow and Unfollow Methods
    func followedBy(userUID: String, program: Program, completion: @escaping (Bool) -> (Void)) {
        // Update Program's 'followersUIDs' locally
        //guard let index = programs.index(of: program) else { completion(false) ; return }
        //programs[index].followersUIDs.append(userUID)
        
        // Append to Program's 'followersUIDs' with --> User's 'uid' in Firestore
        let programRef = db.collection(DatabaseReference.programDatabase).document(program.uid)
        programRef.updateData([
            "followersUIDs": FieldValue.arrayUnion([self.userUID])
        ]) { (error) in
            if let error = error {
                print("Error adding Users's uid to Program's followersUIDs arrray: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Appended uid to Program's followersUIDs array")
                completion(true)
            }
        }
    }
    
    func unfollowedBy(userUID: String, program: Program, completion: @escaping (Bool) -> (Void)) {
        
        // Append to Program's 'followersUIDs' with --> User's 'uid' in Firestore
        let programRef = db.collection(DatabaseReference.programDatabase).document(program.uid)
        programRef.updateData([
            "followersUIDs": FieldValue.arrayRemove([self.userUID])
        ]) { (error) in
            if let error = error {
                print("Error removing Users's uid from Program's followersUIDs array: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Removed uid from Program's followersUIDs array")
                completion(true)
            }
        }
    }
    
    // MARK: - Load All User Created Programs
    func loadPrograms(completion: @escaping () -> ()) {
        
        db.collection(DatabaseReference.programDatabase).whereField("creatorUID", isEqualTo: userUID)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error loading data: \(error.localizedDescription)")
                    return completion()
                }
                self.programs = []
                
                // Found querySnapshot!.documents.count documents in the Program snapshot
                for document in querySnapshot!.documents {
                    let program = Program(document: document.data())
                    //                    guard let program = Program(document: document) else {
                    //                        completion()
                    //                        return
                    //                    }
                    self.programs.append(program)
                }
                completion()
        }
    }
    
    // MARK: - Fetch Programs
    func fetchProgramsByNameWith(text: String, completion: @escaping ([Program]) -> (Void)) {
        // Hold programs that contain text
        var programs: [Program] = []
        
        db.collection(DatabaseReference.programDatabase).getDocuments { (querrySnapshot, error) in
            if let error = error {
                print("Error fetching programs by name \(error.localizedDescription)")
                completion([])
                return
            }
            //
            for document in querrySnapshot!.documents {
                // Check to see if current document's (program) name contains search string else return
                if let name = document["name"] as? String, name.lowercased().contains(text.lowercased()),
                    let creatorUID = document["creatorUID"] as? String, creatorUID != self.userUID  {
                    let program = Program(document: document.data())
                    programs.append(program)
                }
                
            }
            completion(programs)
            return
        }
    }
    
    func getUserFollowedAndCreatedPrograms(completion: @escaping (_ followedPrograms: [Program], _ createdPrograms: [Program]) -> Void) {
        var createdPrograms: [Program] = []
        var followedPrograms: [Program] = []
        
        programDBRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error gettings all User followed programs: \(error.localizedDescription)")
                completion([],[])
                return
            }
            guard let querySnapshot = querySnapshot else { return }
            
            for document in querySnapshot.documents {
                let creatorUID = document["creatorUID"] as? String
                let followersUIDs = document["followersUIDs"] as? [String] ?? []
                
                // if document.creatorUID == userUID add to the createdPrograms array
                // if document.followersUIDs array contains userUID then add to follwoed rograms array
                if creatorUID == self.userUID {
                    let program = Program(document: document.data())
                    createdPrograms.append(program)
                } else if followersUIDs.contains(self.userUID){
                    let program = Program(document: document.data())
                    followedPrograms.append(program)
                }
            }
            completion(followedPrograms, createdPrograms)
        }
    }
    
    // Get and set all userFollowedandCreatedPrograms in the controller
    func setUserFollowedAndCreatedPrograms(completion: @escaping (Bool) -> Void) {
        var createdPrograms: [Program] = []
        var followedPrograms: [Program] = []

        //programDBRef.addSnapshotListener(<#T##listener: FIRQuerySnapshotBlock##FIRQuerySnapshotBlock##(QuerySnapshot?, Error?) -> Void#>)
        //programDBRef
        
        
        programDBRef
            //.whereField("creatorUID", isEqualTo: userUID)
            .whereField("followersUIDs", arrayContains: userUID)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error gettings all User followed programs: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                guard let querySnapshot = querySnapshot else { return }
                //self.createdPrograms = []
                followedPrograms = []
                for document in querySnapshot.documents {
                    let creatorUID = document["creatorUID"] as? String
                    let followersUIDs = document["followersUIDs"] as? [String] ?? []
                    
                    // if document.creatorUID == userUID add to the createdPrograms array
                    // if document.followersUIDs array contains userUID then add to follwoed rograms array
                    if creatorUID == self.userUID {
                        let program = Program(document: document.data())
                        createdPrograms.append(program)
                    } else if followersUIDs.contains(self.userUID){
                        let program = Program(document: document.data())
                        followedPrograms.append(program)
                    }
                }
                
//                self.createdPrograms = createdPrograms
//                self.followedPrograms = followedPrograms
                //completion(true)
        }
        
        
        programDBRef
            .whereField("creatorUID", isEqualTo: userUID)
            //.whereField("followersUIDs", arrayContains: userUID)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error gettings all User followed programs: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                guard let querySnapshot = querySnapshot else { return }
                createdPrograms = []
                //self.followedPrograms = []
                for document in querySnapshot.documents {
                    let creatorUID = document["creatorUID"] as? String
                    let followersUIDs = document["followersUIDs"] as? [String] ?? []
                    
                    // if document.creatorUID == userUID add to the createdPrograms array
                    // if document.followersUIDs array contains userUID then add to follwoed rograms array
                    if creatorUID == self.userUID {
                        let program = Program(document: document.data())
                        createdPrograms.append(program)
                    } else if followersUIDs.contains(self.userUID){
                        let program = Program(document: document.data())
                        followedPrograms.append(program)
                    }
                }
                
                self.createdPrograms = createdPrograms
                self.followedPrograms = followedPrograms
                completion(true)
        }
        
        
        
        
//        programDBRef.getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error gettings all User followed programs: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            guard let querySnapshot = querySnapshot else { return }
//
//            for document in querySnapshot.documents {
//                let creatorUID = document["creatorUID"] as? String
//                let followersUIDs = document["followersUIDs"] as? [String] ?? []
//
//                // if document.creatorUID == userUID add to the createdPrograms array
//                // if document.followersUIDs array contains userUID then add to follwoed rograms array
//                if creatorUID == self.userUID {
//                    let program = Program(document: document.data())
//                    createdPrograms.append(program)
//                } else if followersUIDs.contains(self.userUID){
//                    let program = Program(document: document.data())
//                    followedPrograms.append(program)
//                }
//            }
//
//            self.createdPrograms = createdPrograms
//            self.followedPrograms = followedPrograms
//            completion(true)
//        }
    }
}
