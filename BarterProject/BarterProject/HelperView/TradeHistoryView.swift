//
//  TradeHistoryView.swift
//  BarterProject
//
//  Created by Claudia Chua on 10/11/21.
//

import SwiftUI

struct TradeHistoryView: View {
  
  var currentUser: User
  var tradeViewModel = TradeViewModel()
  @State var requesteeCompletedTrade = [Trade]()
  @State var requestorCompletedTrade = [Trade]()
  
  
  var body: some View {
    
    Text("Trade History")
    
    VStack {
      Text("Trade Requested from Others")
      List(requesteeCompletedTrade,id: \.self) { trade in
        VStack(alignment: .leading) {
          HStack {
            Text(trade.requestorItemName).font(.headline)
            Spacer()
            Text(trade.status)
          }
          Text("for : " + trade.requesteeItemName).font(.subheadline)
        }
      }
      
      Text("Trade Initiated By You")
      List(requestorCompletedTrade,id: \.self) { trade in
        VStack(alignment: .leading) {
          HStack {
            Text(trade.requesteeItemName).font(.headline)
            Spacer()
            Text(trade.status)
          }
          Text("for : " + trade.requestorItemName).font(.subheadline)
        }
      }
      
    }
   .onAppear {
  
      self.tradeViewModel.getCompletedRequesteeTrade(userid: currentUser.id!) { (trades) in
        if trades != nil {
          DispatchQueue.main.async {
            self.requesteeCompletedTrade = trades!
          }
        }
      }
      
      self.tradeViewModel.getCompletedRequestorTrade(userid: currentUser.id!) { (trades) in
        if trades != nil {
          DispatchQueue.main.async {
            self.requestorCompletedTrade = trades!
          }
        }
      }
    }
    
  }
}


