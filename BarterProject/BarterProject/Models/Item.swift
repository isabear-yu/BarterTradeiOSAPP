//
//  Item.swift
//  CMUBarterProject
//
//  Created by Claudia Chua on 10/20/21.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Item: Identifiable, Codable, Hashable {
  
  @DocumentID public var id: String?
  let name: String
  let condition: String
  let img: String?
  let description: String
  let availability: Bool
  let ownerId: String
  let ownerName: String
  let createdDate: Date
  let interestedUsers: [String]
  let trades : [String]
  let tradeLocationName: String
  let tradeLocationAddress: String
  let tradeLocationCoordinates: GeoPoint
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case condition
    case img
    case description
    case availability
    case ownerId
    case ownerName
    case createdDate
    case interestedUsers
    case tradeLocationName
    case tradeLocationAddress
    case tradeLocationCoordinates
    case trades
  }
}
