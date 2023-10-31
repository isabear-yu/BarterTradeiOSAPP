//
//  ItemController.swift
//  CMUBarterProject
//
//  Created by Claudia Chua on 10/21/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import SwiftUI
import FirebaseStorage

class ItemViewModel: ObservableObject {
  
  @Published var items = [Item]()
  
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
  
  //Getting All Items from Firestore
  func subscribe(currentUser: User) {
    
    if listenerRegistration == nil {
      listenerRegistration = db.collection("items").whereField("availability", isEqualTo: true).whereField("ownerId", isNotEqualTo: currentUser.id!).addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.items = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Item.self)
        }
      }
    }
  }
  
  //Trigger to add Item to Firestore and add Img to Storage
  func addItemToFirebase(image: UIImage?, name: String, condition: String, description: String, landmark: Landmark?, user: User) {
        
    if image != nil  {
      //Add Image to Firebase Storage
      ImageUploader.addImgToStorage(image: image!) {
        (documentID) in
        if documentID != nil {
          //Add Item to Firestore
          let newItem = Item(
            name: name,
            condition: condition,
            img: documentID,
            description: description,
            availability: true,
            ownerId: user.id!,
            ownerName: user.name,
            createdDate: Date(),
            interestedUsers: [String](),
            trades: [String](),
            tradeLocationName: landmark!.name,
            tradeLocationAddress: landmark!.title,
            tradeLocationCoordinates: FirebaseFirestore.GeoPoint(latitude: landmark!.coordinate.latitude, longitude: landmark!.coordinate.longitude))
          
          let docref = self.addItemToFirestore(item: newItem)
          print("add item to firebase complete: " + docref)
        }
      }
    }
  }
  
  //Adding Item to Firestore
  func addItemToFirestore(item: Item) -> String {
    var ref: DocumentReference? = nil
    do {
      try ref = db.collection("items").addDocument(from: item)
      print("Document added with ID: \(ref!.documentID)")
      return ref!.documentID
    } catch let err {
      print("ERROR: Could not write Item to Firestore : \(err)")
    }
    return ""
  }
  

  //Get list of own items that are available
  func getOwnItems(userid: String, completion: @escaping ([Item]?) -> ()) {
    db.collection("items").whereField("ownerId", isEqualTo: userid).whereField("availability", isEqualTo: true).getDocuments() {
      (querySnapshot, err) in
      
      guard let documents = querySnapshot?.documents else {
        print("No items")
        return completion(nil)
      }
      
      let allItems = documents.compactMap { queryDocumentSnapshot in
        try? queryDocumentSnapshot.data(as: Item.self)
      }
      return completion(allItems)
    }
  }
  
  //Get list of own items
  func getAllOwnItems(userid: String, completion: @escaping ([Item]?) -> ()) {
    db.collection("items").whereField("ownerId", isEqualTo: userid).getDocuments() {
      (querySnapshot, err) in
      
      guard let documents = querySnapshot?.documents else {
        print("No items")
        return completion(nil)
      }
      
      let allItems = documents.compactMap { queryDocumentSnapshot in
        try? queryDocumentSnapshot.data(as: Item.self)
      }
      return completion(allItems)
    }
  }
  
  //Get list of tradesID that is related to item
  func getRelatedTradesID(itemId: String, completion: @escaping ([String]) -> ()) {
    
    db.collection("items").document(itemId).getDocument() { (document,error) in
      if let document = document {
        let tradeIds = document.get("trades") as? [String]
        if tradeIds != nil {
          return completion(tradeIds!)
        }
        return completion([String]())
      }
    }
  }
  
}
