//
//  UserViewModel.swift
//  CMUBarterProject
//
//  Created by Claudia Chua on 27/10/21.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import UIKit
import SwiftUI

class UserViewModel: ObservableObject {
  
  @Published var users = [User]()
  
  private let db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
  
  deinit {
    unsubscribe()
  }
  
  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  //Get all users
  func subscribe() {
    if listenerRegistration == nil {
      listenerRegistration = db.collection("users").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.users = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: User.self)
        }
      }
    }
  }
  
  func addNewUser(image: UIImage?, name: String, email: String, username: String, password: String) {
    
    var imageid : String? = ""
    
    if image != nil  {
      //Add Image to Firebase Storage
      ImageUploader.addImgToStorage(image: image!) {
        (documentID) in
        imageid = documentID
      }
    }
      
    let newUser = User(
      email: email,
      name: name,
      ratings: 5,
      username: username,
      password: password,
      image: imageid)
    
    let docRef = self.addUserToFirestore(user: newUser)
    
    print("User added " + docRef)
  }
  
  //Adding User to Firestore
  func addUserToFirestore(user: User) -> String {
    var ref: DocumentReference? = nil
    do {
      try ref = db.collection("users").addDocument(from: user)
      print("Document added with ID: \(ref!.documentID)")
      return ref!.documentID
    } catch let err {
      print("ERROR: Could not write User to Firestore : \(err)")
    }
    return ""
  }
  
  func usernameExist(username: String, completion: @escaping(Bool)->()) {
    db.collection("users").whereField("username", isEqualTo: username).getDocuments() {
      (querySnapshot, err) in
      guard (querySnapshot?.documents) != nil  && ((querySnapshot?.documents)!.count > 0) else {
        return completion(false)
      }
      return completion(true)
    }
  }
  
  func emailExist(email: String, completion: @escaping(Bool)->()) {
    db.collection("users").whereField("email", isEqualTo: email.lowercased()).getDocuments() {
      (querySnapshot, err) in
      guard (querySnapshot?.documents) != nil && ((querySnapshot?.documents)!.count > 0) else {
        return completion(false)
      }
      return completion(true)
    }
  }
    
    //Get User
    func getUser(userId:String, completion: @escaping (User?) -> ()) {
        print("Tyring to get user!")
        let userRef = db.collection("users").document(userId)
        var finalUser:User? = nil
        userRef.getDocument{(document, error) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    finalUser = user
                    return completion(finalUser)
                } else {
                    return completion(nil)
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
                return completion(nil)
            }
        }
    }
    
    func addImgToStorage(image: UIImage, completion: @escaping (String?) -> ()) {
        let storage = Storage.storage()
        //convert UIImage to Data type so that it can be save to Firebase Storage
        guard let imgData = image.jpegData(compressionQuality: 0.2) else {
            print("ERROR: Could not convert image to data format")
            return completion(nil)
        }
        
        //create metadata so that we can see images in the Firebase Storage console
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        //create filename
        let documentID = UUID().uuidString
        
        //create a storage reference to upload this image file
        let storageRef = storage.reference().child(documentID)
        
        //create upload task
        let uploadTask = storageRef.putData(imgData, metadata: uploadMetaData) { (metadata, error) in if let error = error {
            print("ERROR: upload for ref \(uploadMetaData) failed. \(error.localizedDescription)")
        }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            print("Upload to Firebase Storage was successful")
            return completion(documentID)
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("ERROR: upload task for file \(documentID) failed, with error \(error.localizedDescription)")
            }
            return completion(nil)
        }
    }
    
  func updateUser(currentProfile: User, newProfile: User) {
    
    db.collection("users").document(currentProfile.id!).updateData([ "name":newProfile.name,
       "email":newProfile.email,
       "username":newProfile.username,
       "password":newProfile.password
    ])
  }
  
}
