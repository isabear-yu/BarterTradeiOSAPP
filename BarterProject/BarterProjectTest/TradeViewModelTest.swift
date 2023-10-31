//
//  TradeViewModelTest.swift
//  BarterProjectTests
//
//  Created by Claudia Chua on 30/11/21.
//

@testable import BarterProject
import FirebaseFirestore
import XCTest

class TradeViewModelTest: XCTestCase {

  var tradeViewModel: TradeViewModel!
  
  override func setUp() {
    super.setUp()
    tradeViewModel = TradeViewModel()
  }
  
  override func tearDown() {
    tradeViewModel = nil
    super.tearDown()
  }
  
  func test_is_offer_item_not_empty() {
    let testExpectation = expectation(description: "Expected getOfferedItems completion handler to be called")
    tradeViewModel.getOfferedItems(userid: "0") { (respond) in
      XCTAssertNotNil(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)

  }
  
  func test_is_offer_item_empty() {
    let testExpectation = expectation(description: "Expected getOfferedItems completion handler to be called")
    tradeViewModel.getOfferedItems(userid: "00") { (respond) in
      XCTAssertEqual(respond,[String]())
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_is_pending_requestor_trade() {
    let testExpectation = expectation(description: "Expected getPendingRequestorTrade completion handler to be called")
    tradeViewModel.getPendingRequestorTrade(userid: "0") { (respond) in
        XCTAssertNotNil(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)

  }
  
  func test_is_pending_requestor_trade_empty() {
    let testExpectation = expectation(description: "Expected getPendingRequestorTrade completion handler to be called")
    tradeViewModel.getPendingRequestorTrade(userid: "00") { (respond) in
      XCTAssertEqual(respond,[Trade]())
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_is_pending_requestee_trade() {
    let testExpectation = expectation(description: "Expected getPendingRequesteeTrade completion handler to be called")
    tradeViewModel.getPendingRequesteeTrade(userid: "1") { (respond) in
      XCTAssertNotNil(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_is_pending_requestee_trade_empty() {
    let testExpectation = expectation(description: "Expected getPendingRequesteeTrade completion handler to be called")
    tradeViewModel.getPendingRequesteeTrade(userid: "00") { (respond) in
      XCTAssertEqual(respond,[Trade]())
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_is_completed_requestee_trade() {
    let testExpectation = expectation(description: "Expected getCompletedRequesteeTrade completion handler to be called")
    tradeViewModel.getCompletedRequesteeTrade(userid: "0") { (respond) in
      XCTAssertNotNil(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_is_completed_requestee_trade_empty() {
    let testExpectation = expectation(description: "Expected getCompletedRequesteeTrade completion handler to be called")
    tradeViewModel.getCompletedRequesteeTrade(userid: "00") { (respond) in
      XCTAssertEqual(respond,[Trade]())
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_is_completed_requestor_trade() {
    let testExpectation = expectation(description: "Expected getCompletedRequestorTrade completion handler to be called")
    tradeViewModel.getCompletedRequestorTrade(userid: "1") { (respond) in
      XCTAssertNotNil(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_is_completed_requestor_trade_empty() {
    let testExpectation = expectation(description: "Expected getCompletedRequestorTrade completion handler to be called")
    tradeViewModel.getCompletedRequestorTrade(userid: "00") { (respond) in
      XCTAssertEqual(respond,[Trade]())
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }

  func test_create_trade() {
    
    let testExpectation = expectation(description: "Expected createTrade completion handler to be called")
    
    let testRequesteeItem = Item(id: "0", name: "test", condition: "used", img: "0", description: "0", availability: true, ownerId: "0", ownerName: "test", createdDate: Date(), interestedUsers: [String](), trades: [String](), tradeLocationName: "Test", tradeLocationAddress: "Test", tradeLocationCoordinates: FirebaseFirestore.GeoPoint(latitude: 40.4395, longitude: -80.0038))
    
    let testRequestorItem = Item(id: "0", name: "test", condition: "used", img: "0", description: "0", availability: true, ownerId: "0", ownerName: "test", createdDate: Date(), interestedUsers: [String](), trades: [String](), tradeLocationName: "Test", tradeLocationAddress: "Test", tradeLocationCoordinates: FirebaseFirestore.GeoPoint(latitude: 40.4395, longitude: -80.0038))
    
    let tradeRef = tradeViewModel.createTrade(requesteeItem: testRequesteeItem, requestorItem: testRequestorItem)
    
    let db = Firestore.firestore()
    
    let docRef = db.collection("trades").document(tradeRef)
    
    docRef.getDocument { (document, error) in
      
      if let document = document, document.exists {

        //delete document
        db.collection("trades").document(tradeRef).delete() { err in
            if let err = err {
              print("Error removing document: \(err)")
            } else {
              XCTAssert(true)
              testExpectation.fulfill()
              print("Document successfully removed!")
        
            }
        }
      }
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_change_trade_status() {
    
    let testExpectation = expectation(description: "Expected changeTradeStatus completion handler to be called")
    
    let db = Firestore.firestore()

    //Extract out test trade
    db.collection("trades").document("0").getDocument { [self]
      (document, error) in

      let result = Result {
          try document.flatMap {
              try $0.data(as: Trade.self)
          }
    }
      switch result {
        case .success(let trade):
            if let tradeTest = trade {

              //Change Status
              tradeViewModel.changeTradeStatus(trade: tradeTest, response: "Accepted")
              
              //Check Status
              let docRef =  db.collection("trades").document("0")
              
              docRef.getDocument { (document, error) in
                  if let document = document, document.exists {
                    let property = document.get("status")
                    XCTAssertEqual(property as! String,"Accepted")

                    testExpectation.fulfill()
                    
                    //Change Back Status
                    db.collection("trades").document("0").updateData(["status":"Pending"])
                  }
              }
            }
      case .failure(_):
           XCTAssert(false)
        }
    }
  
    waitForExpectations(timeout: 1, handler: nil)
  }
}
