//
//  UserController.swift
//  Workout
//
//  Created by Chris Grayston on 4/5/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    // MARK: - Properties
    var currentUser: User?
    
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
    static let shared = UserController()
    
    
    // MARK: - Initilize
    init() {
        db = Firestore.firestore()
    }
    
    // MARK: - CRUD
    
    // Update
    func addCreatedProgramUID(programUID: String, completion: @escaping (Bool) -> (Void)) {
        // Add locally TODO do I need to unwrap??
        currentUser!.createdPrograms.append(programUID)
        
        // Add to Firestore
        db.collection(DatabaseReference.userDatabase).document(userUID).updateData([
            "createdPrograms": FieldValue.arrayUnion([programUID])
        ]) { (error) in
            if let error = error {
                print("Error adding programUID to User: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                // Appended createdPrograms array
                print("Appended createdPrograms array")
                completion(true)
                return
            }
        }
    }
    
    // Remove
    func removeCreatedProgramUID(programUID: String, completion: @escaping (Bool) -> (Void)) {
        // Remove locally TODO do I need to unwrap??
        guard let index = currentUser?.createdPrograms.index(of: programUID) else { return }
        currentUser!.createdPrograms.remove(at: index)
        
        // Remove from Firestore
        db.collection(DatabaseReference.userDatabase).document(userUID).updateData([
            "createdPrograms": FieldValue.arrayRemove([programUID])
        ]) { (error) in
            if let error = error {
                print("Error removing programUID from User: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                // Appended createdPrograms array
                print("Removed createdProgram from array in User")
                completion(true)
                return
            }
        }
    }
    
    // MARK: - Follow and Unfollow Programs
    func followProgram(program: Program, completion: @escaping (Bool, _ response: String) -> (Void)) {
        let userRef = db.collection(DatabaseReference.userDatabase).document(userUID)
        
        // Make sure we have a current user and we arent already following program
        guard let currentUser = currentUser, !currentUser.followedPrograms.contains(program.uid) else { completion(true, "Already Following") ; return }
        
        // Update locally
        self.currentUser?.followedPrograms.append(program.uid)
        
        // Append Program's 'uid' to User's 'followedPrograms' array in Firestore
        userRef.updateData([
            "followedPrograms": FieldValue.arrayUnion([program.uid])
        ]) { (error) in
            if let error = error {
                print("Error adding programUID to User's followedPrograms arrray: \(error.localizedDescription)")
                completion(false, "Error adding programUID to User's followedPrograms arrray")
            } else {
                print("Appended programUID to User's followedPrograms array")
                
                // Append to Program's 'followersUIDs' with --> User's 'uid' in Firestore and locally
                ProgramController.shared.followedBy(userUID: self.userUID, program: program, completion: { (success) -> (Void) in
                    completion(success, "Following program")
                    return
                })
            }
        }
    }
    
    func unfollowProgram(program: Program, completion: @escaping (Bool, _ response: String) -> (Void)) {
        let userRef = db.collection(DatabaseReference.userDatabase).document(userUID)
        
        // Make sure we have a current user and we are currently following program
        guard let currentUser = currentUser, currentUser.followedPrograms.contains(program.uid) else { completion(true, "Not Following") ; return }
        
        // Update locally
        guard let index = self.currentUser?.followedPrograms.index(of: program.uid) else { completion(false, "Error: Couldn't find index of program") ; return }
        self.currentUser?.followedPrograms.remove(at: index)
        
        
        // Remove Program's 'uid' from User's 'followedPrograms' array in Firestore
        userRef.updateData([
            "followedPrograms": FieldValue.arrayRemove([program.uid])
        ]) { (error) in
            if let error = error {
                print("Error removing programUID from User's followedPrograms array: \(error.localizedDescription)")
                completion(false, "Error removing programUID from User's followedPrograms array: \(error.localizedDescription)")
            } else {
                print("Removed programUID from User's followedPrograms array")
                
                // Append to Program's 'followersUIDs' with --> User's 'uid' in Firestore and locally
                ProgramController.shared.unfollowedBy(userUID: self.userUID, program: program, completion: { (success) -> (Void) in
                    completion(success, "Unfollowed program")
                })
            }
        }
    }
    
    // MARK: - Load User from Firestore
    func loadUser(completion: @escaping () -> ()) {
        db.collection(DatabaseReference.userDatabase).document(userUID).addSnapshotListener { (document, error) in
            if let error = error {
                print("Error loading data: \(error.localizedDescription)")
                completion()
                return
            } else {
                
                guard let documentData = document?.data() else { completion() ; return }
                let user = User(dictionary: documentData)
                self.currentUser = user
                completion()
                return
            }
            
        }
    }
}
