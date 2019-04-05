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
    
    var db: Firestore!
    
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
    }
    
    // MARK: - CRUD Functions
    
    // Create Program
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
            "uid": program.uid
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                completion(false, nil)
                return
            } else {
                print("Document successfully created!")
                completion(true, program)
                return
            }
        }
    }
    
    // Update Program
    func updateProgram(program: Program, name: String, description: String, photoURL: String, completion: @escaping (Bool) -> Void) {
        // Update Program locally
        guard let index = programs.index(of: program) else { completion(false) ; return }
        programs[index].name = name
        programs[index].description = description
        programs[index].photoURL = photoURL
        
        // Update Program on Firestore
        db.collection(DatabaseReference.programDatabase).document(program.uid).setData([
            "creatorUID": userUID,
            "name": name,
            "description": description,
            "photoURL": photoURL,
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
    
    // Delete Program
    func deleteProgram(program: Program, completion: @escaping (Bool) -> Void) {
        // Delete locally
        guard let index = self.programs.index(of: program) else { return }
        self.programs.remove(at: index)
        
        // Delete from Firestore
        db.collection(DatabaseReference.programDatabase).document(program.uid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                completion(false)
            } else {
                print("Document successfully removed!")
                completion(true)
            }
        }
        
        // Delete all workouts that stem from that program
        deleteProgramsWorkouts(programUID: program.uid) {
        }
    }
    
    private func deleteProgramsWorkouts(programUID: String, completion: @escaping () -> ()) {
        // Delete all workouts that stem from that program
        
        // Go through workout collection
        db.collection(DatabaseReference.workoutDatabase).whereField("programUID", isEqualTo: programUID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
            
            for document in querySnapshot!.documents {
                document.reference.delete()
            }
        }
        
        
        // Check if UID == programUID
        
        // Delete that workout
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
}
