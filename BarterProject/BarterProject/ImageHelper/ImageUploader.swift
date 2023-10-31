//
//  ImageUploader.swift
//  BarterProject
//
//  Created by Claudia Chua on 18/11/21.
//

import Combine
import SwiftUI
import FirebaseStorage

struct ImageUploader {
  
  static func addImgToStorage(image: UIImage, completion: @escaping (String?) -> ()) {
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
  
  
}
