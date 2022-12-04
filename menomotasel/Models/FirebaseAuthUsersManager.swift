//
//  FirebaseAuthUsersManager.swift
//  menodag
//
//  Created by Osama Rabie on 12/07/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Singleton shared access to the  users module on Firebase
let sharedFirebaseAuthUsersManager = FirebaseAuthUsersManager()

/// A closure to be called once the data about a user is fetched from the firestore
typealias fetchUserFromFireStoreClosure = ([String:String]?,QueryDocumentSnapshot?) -> ()

/// Responsible for accessing the  users module on Firebase
class FirebaseAuthUsersManager {
    
    
    // MARK: - public functions
    
    // MARK: - Firebase Firestore functions
    
    
    /// Updates the current logged in user's profile with the data matched in the proveded
    /// - Parameter with card: The card model that will be stored in the user's profile in firebase
    func updateCurrentUserProfile(with card:CardModel) {
        // update auth data
        updateCurrentUserProfileOnAuth(with: card)
        // update firestore data
        updateCurrentUserProfileOnFireStore(with: card)
    }
    
    /// Fetches the data of the current logged in user if any. Nil otherwise
    func fetchUserData(onComplete:fetchUserFromFireStoreClosure?) {
        
        // check if there is a logged in user first
        guard let user = loggedInUser() else {
            onComplete?(nil,nil)
            return
        }
        
        // Now fetch if by the ID
        let db = Firestore.firestore()
        // Create a reference to the users collection
        let usersRef = db.collection("Users")
        // Create a query against the collection. to fetch the user document with the same UI of the logged in user
        usersRef.whereField("uid", isEqualTo: user.uid).getDocuments { snapshot, error in
            // Make sure no errors happened
            if let _ = error {
                onComplete?(nil,nil)
                return
            }
            // Make sure is a document with the provided id
            guard let snapshot = snapshot,
                  snapshot.documents.count > 0,
            let userData:[String:String] = snapshot.documents.first?.data() as? [String:String] else {
                onComplete?(nil,nil)
                return
            }
            
            
            // let us get the document and share its data back :)
            onComplete?(userData,snapshot.documents.first)
        }
    }
    
    // MARK: - Firebase Auth functions
    
    /// Returns the logged in user and null if nothing
    func loggedInUser() -> User? {
        return Auth.auth().currentUser
    }
    
    
    
    // MARK: - Private functions
    /// Updates the current logged in user's profile with the data matched in the proveded
    /// - Parameter with card: The card model that will be stored in the user's profile in firebase
    private func updateCurrentUserProfileOnAuth(with card:CardModel) {
        // Make sure first there is a logged in user
        guard let user = loggedInUser() else { return }
        // Create a change request
        let changeRequest = user.createProfileChangeRequest()
        // Let us update all of the fields one by one now
        user.updateEmail(to: card.email ?? "")
        
        changeRequest.photoURL = URL(string:card.imageURL ?? "")
        changeRequest.displayName = card.fullName
        changeRequest.commitChanges { error in
            
        }
    }
    
    
    /// Updates the current logged in user's profile with the data matched in the proveded
    /// - Parameter with card: The card model that will be stored in the user's profile in firebase
    private func updateCurrentUserProfileOnFireStore(with card:CardModel) {
        // Make sure first there is a logged in user
        guard let user = loggedInUser() else { return }
        // Check if this user has a previous profile to delete it first
        deleteUserFromFireStore { _ in
            // Now let us create a new user with the provided data
            // Add a new document with a generated id.
            var ref: DocumentReference? = nil
            let db = Firestore.firestore()
            
            ref = db.collection("Users").addDocument(data: [
                "company": card.company ?? "",
                "country": card.countryCode ?? "",
                "displayName": card.fullName ?? "",
                "phone": card.phone ?? "",
                "photoURL": card.imageURL ?? "",
                "uid": user.uid,
                "website": card.website ?? "",
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
    
    /// Deletes the current logged in user from firestore if any
    func deleteUserFromFireStore(completion: @escaping (Error?) -> Void) {
        
        // Make sure there is a user stored already for the current user
        fetchUserData(){ _, documentRef in
            guard let documentRef = documentRef else {
                completion(nil)
                return
            }
            documentRef.reference.delete(completion: completion)
        }
        
    }
    
}
