//
//  User.swift
//  CMUBarterProject
//
//  Created by Claudia Chua on 10/21/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    
    @DocumentID public var id: String?
    let email: String
    let name: String
    let ratings: Int
    let username: String
    let password: String
    let image: String?
    
    enum CodingKeys: String, CodingKey {
      case id
      case email
      case name
      case ratings
      case username
      case password
      case image
    }
    
}
