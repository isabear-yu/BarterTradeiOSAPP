//
//  Trade.swift
//  CMUBarterProject
//
//  Created by Claudia Chua on 27/10/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Trade: Identifiable, Codable, Hashable {
  
  @DocumentID public var id: String?
  let date: Date
  let requestorItem: String //the one who intiate the trade
  let requestorItemName: String //the one who intiate the trade
  let requesteeItem: String
  let requesteeItemName: String
  let requestor: String
  let requestorName: String
  let requestee: String
  let requesteeName: String
  let status: String //pending, accepted, rejected
  
  enum CodingKeys: String, CodingKey {
    case id
    case date
    case requestorItem
    case requestorItemName
    case requesteeItem
    case requesteeItemName
    case requestor
    case requestorName
    case requestee
    case requesteeName
    case status
  }
}

