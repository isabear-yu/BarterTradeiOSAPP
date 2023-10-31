//
//  ItemViewModelTest.swift
//  BarterProjectTests
//
//  Created by Claudia Chua on 30/11/21.
//
@testable import BarterProject
import FirebaseFirestore
import XCTest

class ItemViewModelTest: XCTestCase {

  var itemViewModel: ItemViewModel!
  
  override func setUp() {
    super.setUp()
    itemViewModel = ItemViewModel()
  }
  
  override func tearDown() {
    itemViewModel = nil
    super.tearDown()
  }
  
  func test_get_user_items() {
    let testExpectation = expectation(description: "Expected getOwnItems completion handler to be called")
    
    itemViewModel.getOwnItems(userid: "1HF3XjWSNTKlEBVhXKAL") {
      (respond) in
      XCTAssertNotNil(respond)
      testExpectation.fulfill()
    }
      waitForExpectations(timeout: 1, handler: nil)
    }
  
  func test_get_user_items_empty() {
    let testExpectation = expectation(description: "Expected getOwnItems completion handler to be called")
    
    itemViewModel.getOwnItems(userid: "0") {
      (respond) in
      XCTAssertEqual(respond, [Item]())
      testExpectation.fulfill()
    }
      waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_get_all_user_items() {
    let testExpectation = expectation(description: "Expected getAllOwnItems completion handler to be called")
    
    itemViewModel.getAllOwnItems(userid: "1HF3XjWSNTKlEBVhXKAL") {
      (respond) in
      XCTAssertNotNil(respond)
      testExpectation.fulfill()
    }
      waitForExpectations(timeout: 1, handler: nil)
    }
  
  func test_get_all_user_items_empty() {
    let testExpectation = expectation(description: "Expected getAllOwnItems completion handler to be called")
    
    itemViewModel.getAllOwnItems(userid: "0") {
      (respond) in
      XCTAssertEqual(respond, [Item]())
      testExpectation.fulfill()
    }
      waitForExpectations(timeout: 1, handler: nil)
    }
  
  func test_get_related_tradeID() {
    let testExpectation = expectation(description: "Expected getRelatedTradesID completion handler to be called")
    
    itemViewModel.getRelatedTradesID(itemId: "OGLjEvLIyhcwmbdvoxGo") {
      (respond) in
      XCTAssertNotNil(respond)
      testExpectation.fulfill()
    }
      waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_get_related_tradeID_empty() {
    let testExpectation = expectation(description: "Expected getRelatedTradesID completion handler to be called")
    
    itemViewModel.getRelatedTradesID(itemId: "l4sa30Wo2U4TZbtg1GiO") {
      (respond) in
      XCTAssertEqual(respond, [String]())
      testExpectation.fulfill()
    }
      waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_add_item_to_Firestore() {
    
    let testExpectation = expectation(description: "Expected addItemToFirestore completion handler to be called")

    let testItem = Item(id: "0", name: "test", condition: "used", img: "0", description: "0", availability: true, ownerId: "0", ownerName: "test", createdDate: Date(), interestedUsers: [String](), trades: [String](), tradeLocationName: "Test", tradeLocationAddress: "Test", tradeLocationCoordinates: FirebaseFirestore.GeoPoint(latitude: 40.4395, longitude: -80.0038))
    
    let itemref = itemViewModel.addItemToFirestore(item: testItem)
    
    let db = Firestore.firestore()

    let docRef = db.collection("items").document(itemref)
    
    docRef.getDocument { (document, error) in
      
      if let document = document, document.exists {
  
        //delete document
        db.collection("items").document(itemref).delete() { err in
            if let err = err {
              print("Error removing document: \(err)")
            } else {
              print("Document successfully removed!")
              XCTAssert(true)
              testExpectation.fulfill()
            }
        }
      }
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
}
