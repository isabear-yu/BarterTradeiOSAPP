//
//  RequestTradeView.swift
//  BarterProject
//
//  Created by Claudia Chua on 9/11/21.
//

import SwiftUI

struct RequestTradeView: View {
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  var requestItem : Item
  var currentUser : User
  var itemViewModel = ItemViewModel()
  var tradeViewModel = TradeViewModel()
  
  @State var currentUserItems = [Item]()
  @State var userOfferedItemsId = [String]()
  @State var tradeItemSelection : Item?
  @State var tradeSucceed = false
  
  var body: some View {
    
    Text("Requesting Trade for ")
    
    Text(requestItem.name)
    
    Text("with:")
    
    List(currentUserItems,id: \.self) { item in
      
      HStack{
        Text(item.name)
          .font(.headline)
          .foregroundColor(userOfferedItemsId.contains(item.id!) ? Color.gray: Color.black)
          .onTapGesture {
            self.tradeItemSelection = item
          }
        Spacer()
        Text(userOfferedItemsId.contains(item.id!) ? "Pending" : "")
          .foregroundColor(Color.gray)
      }
      .listRowBackground(canBeRequested(item) ? Color.accentColor : Color.white)
    }.onAppear(perform: loadItems)
    
    
    Button(action: {
      if tradeItemSelection != nil && !userOfferedItemsId.contains(tradeItemSelection!.id!) {
        self.tradeSucceed = tradeViewModel.createTrade(requesteeItem: requestItem, requestorItem: tradeItemSelection!) == "" ? false : true
      }
      if self.tradeSucceed {
        self.mode.wrappedValue.dismiss()
      }
    }) {
      Text("Request Trade")
    }.disabled(!canBeRequested(tradeItemSelection))
    
  }
  
  func canBeRequested(_ i: Item?) -> Bool {
    if i != nil {
      if self.tradeItemSelection == i! && !userOfferedItemsId.contains(i!.id!) {
        return true
      }
    }
    return false
  }
  
  
  func loadItems() {

    self.itemViewModel.getOwnItems(userid: currentUser.id!) { (ownItems) in
      if ownItems != nil {
        DispatchQueue.main.async {
          self.currentUserItems = ownItems!
        }
        
      }
    }
    self.tradeViewModel.getOfferedItems(userid: currentUser.id!) { (offeredItems) in
      if offeredItems != nil {
        DispatchQueue.main.async {
          self.userOfferedItemsId = offeredItems!
        }
        
      }
    }
    
  }
  
}
