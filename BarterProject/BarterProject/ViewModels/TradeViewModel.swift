//
//  TradeViewModel.swift
//  CMUBarterProject
//
//  Created by Claudia Chua on 27/10/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class TradeViewModel: ObservableObject {
  
  @Published var trades = [Trade]()
  @Published var requesteePendingTrade = [Trade]()
  @Published var requestorPendingTrade = [Trade]()
  
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
  
  func subscribe(currentUser: User) {
    if listenerRegistration == nil {
      listenerRegistration = db.collection("trades").addSnapshotListener { (querySnapshot, error) in
        
        self.getPendingRequesteeTrade(userid: currentUser.id!) { (trades) in
          if trades != nil {
            DispatchQueue.main.async {
              self.requesteePendingTrade = trades!
            }
          }
        }
        
        self.getPendingRequestorTrade(userid: currentUser.id!) { (trades) in
          if trades != nil {
            DispatchQueue.main.async {
              self.requestorPendingTrade = trades!
            }
          }
        }
      }
    }
  }
  
  //Own items that has been used in other trades
  func getOfferedItems(userid: String, completion: @escaping ([String]?) -> ()) {
    
    db.collection("trades")
      .whereField("requestor", isEqualTo: userid).whereField("status", isEqualTo: "Pending")
      .getDocuments() { (querySnapshot, err) in
        
        guard let documents = querySnapshot?.documents else {
          print("No requestor Trade")
          return completion(nil)
        }
        return completion(documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Trade.self)
        }.compactMap { $0.requestorItem })
      }
    
  }
  
  //Get trades that was initiated by the User
  func getPendingRequestorTrade(userid: String, completion: @escaping ([Trade]?) -> ()) {
    db.collection("trades").whereField("requestor", isEqualTo: userid)
      .whereField("status", isEqualTo: "Pending")
      .getDocuments() { (querySnapshot, err) in
        
        guard let documents = querySnapshot?.documents else {
          print("No requestor Trade")
          return completion(nil)
          
        }
        
        return completion(documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Trade.self)
        })
      }
  }
  
  
  //Get Pending trades that was requested to the User
  func getPendingRequesteeTrade(userid: String, completion: @escaping ([Trade]?) -> ()) {
    
    db.collection("trades").whereField("requestee", isEqualTo: userid)
      .whereField("status", isEqualTo: "Pending")
      .getDocuments() { (querySnapshot, err) in
        
        guard let documents = querySnapshot?.documents else {
          print("No requestee Trade")
          return completion(nil)
        }
        
        return completion(documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Trade.self)
        })
      }
  }
  
  func getCompletedRequesteeTrade(userid: String, completion: @escaping ([Trade]?) -> ()) {
    
    db.collection("trades").whereField("requestee", isEqualTo: userid)
      .whereField("status", in: ["Accepted","Rejected","Cancelled"])
      .getDocuments() { (querySnapshot, err) in
        
        guard let documents = querySnapshot?.documents else {
          print("No requestee Trade")
          return completion(nil)
        }
        
        return completion(documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Trade.self)
        })
      }
  }
  
  func getCompletedRequestorTrade(userid: String, completion: @escaping ([Trade]?) -> ()) {
    
    db.collection("trades").whereField("requestor", isEqualTo: userid)
      .whereField("status", in: ["Accepted","Rejected","Cancelled"])
      .getDocuments() { (querySnapshot, err) in
        
        guard let documents = querySnapshot?.documents else {
          print("No requestor Trade")
          return completion(nil)
        }
        
        return completion(documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Trade.self)
        })
      }
  }
  
  //when user initiate a trade
  func createTrade(requesteeItem: Item, requestorItem: Item) -> String {
    let newTrade = Trade(date: Date() ,requestorItem: requestorItem.id!, requestorItemName: requestorItem.name, requesteeItem: requesteeItem.id!, requesteeItemName: requesteeItem.name, requestor: requestorItem.ownerId, requestorName: requestorItem.ownerName, requestee: requesteeItem.ownerId, requesteeName: requesteeItem.ownerName, status: "Pending")
    
    var ref: DocumentReference? = nil
    do {
      try ref = db.collection("trades").addDocument(from: newTrade)
      print("Document added with ID: \(ref!.documentID)")
      
      //add tradeId to items
      db.collection("items").document(requesteeItem.id!).updateData([
        "trades": FieldValue.arrayUnion([ref!.documentID])
      ])
      db.collection("items").document(requestorItem.id!).updateData([
        "trades": FieldValue.arrayUnion([ref!.documentID])
      ])
      
      return ref!.documentID
    } catch let err {
      print("Error writing Item to Firestore : \(err)")
      return ""
    }
    
  }
  
  //when user accept/reject a trade
  func changeTradeStatus(trade: Trade, response: String) {
    
    db.collection("trades").document(trade.id!).updateData(["status":response])
    
    //Mark items as unavilable
    if response == "Accepted" {
      db.collection("items").document(trade.requestorItem).updateData(["availability":false])
      db.collection("items").document(trade.requesteeItem).updateData(["availability":false])
      
      //Mark other trades as Rejected
      let itemViewModel = ItemViewModel()
      var item1Trades = [String]()
      var item2Trades = [String]()
      
      itemViewModel.getRelatedTradesID(itemId: trade.requestorItem) { trade1 in
        item1Trades = trade1
        itemViewModel.getRelatedTradesID(itemId: trade.requesteeItem) { trade2 in
          item2Trades = trade2
          let allTrades = self.combine(item1Trades,item2Trades).filter { $0 != trade.id! }
          for tradeId in allTrades {
            self.db.collection("trades").document(tradeId).updateData(["status":"Rejected"])
          }
        }
      }
    }
  }
  
  func combine<T>(_ arrays: Array<T>?...) -> Set<T> {
    return arrays.compactMap{$0}.compactMap{Set($0)}.reduce(Set<T>()){$0.union($1)}
  }
}
