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
    func createProgram(completion: @escaping (Bool) -> Void) {
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
                completion(false)
                return
            } else {
                print("Document successfully created!")
                completion(true)
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
            "name": name,
            "description": description,
            "photoURL": photoURL
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
    func deleteProgram(uid: String, completion: @escaping (Bool) -> Void) {
        // TODO
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
                    guard let program = Program(document: document) else {
                        completion()
                        return
                    }
                    self.programs.append(program)
                }
                completion()
        }
    }
}
