//
//  UserViewModelTest.swift
//  BarterProjectTests
//
//  Created by Claudia Chua on 30/11/21.
//

@testable import BarterProject
import XCTest
import FirebaseFirestore

class UserViewModelTest: XCTestCase {
  
  var userViewModel: UserViewModel!
  
  override func setUp() {
    super.setUp()
    userViewModel = UserViewModel()
  }
  
  override func tearDown() {
    userViewModel = nil
    super.tearDown()
  }
  
  func test_username_exist() {
    let testExpectation = expectation(description: "Expected usernameExist completion handler to be called")
    
    userViewModel.usernameExist(username: "test") {
      (respond) in
      XCTAssertTrue(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_username_not_exist() {
    let testExpectation = expectation(description: "Expected usernameExist completion handler to be called")
    userViewModel.usernameExist(username: "testtest") {
      (respond) in
      XCTAssertFalse(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_email_exist() {
    let testExpectation = expectation(description: "Expected emailExist completion handler to be called")
    
    userViewModel.emailExist(email: "test@email.com") {
      (respond) in
      XCTAssertTrue(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_email_not_exist() {
    let testExpectation = expectation(description: "Expected emailExist completion handler to be called")
    userViewModel.emailExist(email: "testtest") {
      (respond) in
      XCTAssertFalse(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_get_user() {
    let testExpectation = expectation(description: "Expected getUser completion handler to be called")
    
    userViewModel.getUser(userId: "0") {
      (respond) in
      XCTAssertNotNil(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_get_user_nil() {
    let testExpectation = expectation(description: "Expected getUser completion handler to be called")
    
    userViewModel.getUser(userId: "123") {
      (respond) in
      XCTAssertNil(respond)
      testExpectation.fulfill()
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func test_add_new_user_to_firestore() {
    let testExpectation = expectation(description: "Expected addUserToFirestore completion handler to be called")
    
    let testUser = User(email: "testcase", name: "testcase", ratings: 0, username: "testcase", password: "testcase", image: "")
    
    let userRef = userViewModel.addUserToFirestore(user: testUser)
    
    let db = Firestore.firestore()
    
    let docRef = db.collection("users").document(userRef)
    
    docRef.getDocument { (document, error) in
      
      if let document = document, document.exists {
        
        //delete document
        db.collection("users").document(userRef).delete() { err in
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
  
  func test_update_user() {
    
    let testExpectation = expectation(description: "Expected updateUser completion handler to be called")
    
    let db = Firestore.firestore()
    
    //Get test User
    userViewModel.getUser(userId: "0") { (respond) in
      if let currentProfile = respond {
        let newProfile = User(email: "abc@email.com", name: "testtest", ratings: currentProfile.ratings, username: "a", password: "b", image: "")
        
        //Update User
        self.userViewModel.updateUser(currentProfile: currentProfile, newProfile: newProfile)
        
        //Check update
        let docRef =  db.collection("users").document("0")
        
        docRef.getDocument { (document, error) in
          if let document = document, document.exists {
            let name = document.get("name")
            let username = document.get("username")
            let email = document.get("email")
            let password = document.get("password")
            
            //Assert ALL
            XCTAssertEqual(email as! String,"abc@email.com")
            XCTAssertEqual(name as! String,"testtest")
            XCTAssertEqual(username as! String,"a")
            XCTAssertEqual(password as! String,"b")
            
            //Change Back to Old Profile
            db.collection("users").document("0").updateData([
              "name":"test",
              "email":"test@email.com",
              "username":"test",
              "password":"test"])
            
            testExpectation.fulfill()
          }
        }
      }
    }
    waitForExpectations(timeout: 1, handler: nil)
  }
}
