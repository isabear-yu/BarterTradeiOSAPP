//
//  ItemDetail.swift
//  BarterProject
//
//  Created by Jessie Shao on 11/2/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct ItemDetail: View {
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  var item: Item
  var currentUser: User
  
  @State var ownItem = false
  @State var requestTrade: Bool = false
  
  var body: some View {
    ZStack{
        Color(.systemGray6)
            .edgesIgnoringSafeArea(.all)
    VStack(alignment:.center) {
      Spacer()
        
        FirebaseItemImage(id: item.img!)
            .aspectRatio(contentMode: .fit)
            Spacer()
       
     
        
      Spacer()
      VStack (alignment: .leading){
          VStack(alignment: .leading) {
              Text(item.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
          }
          .padding(.top)
          .frame(maxWidth: .infinity, alignment: .leading)
        
            HStack {
              Text("Condition:")
                .font(.headline)
                .padding()
              Text(item.condition)
            }
            HStack {
              Text("Availability:")
                .font(.headline)
                .padding()
              Text(String(item.availability))
            }
            HStack{
              Text("Posted on:")
                .font(.headline)
                .padding()
              Text(item.createdDate,style: .date)
            }
            HStack{
              Text("Posted by:")
                .font(.headline)
                .padding()
              Text(item.ownerName)
            }
        
            Text("Description:")
                .font(.headline)
                .padding(.leading)
                
            Text(item.description)
                .padding(.leading)
                
        if !ownItem {
             HStack() {

                Spacer()
               Button("Request Trade") {
                 self.requestTrade = true
               }.sheet(isPresented: $requestTrade, content: {
                 RequestTradeView(requestItem: item, currentUser: currentUser)
               })
               .foregroundColor(.white)
               .font(.headline)
               .padding()
               .background(Color(.gray))
               .cornerRadius(30)
                Spacer()
             }
             
         }
        
   
      }.padding()
      .background(Color(.white))
      .cornerRadius(30)
      
      
    }.onAppear {
      if (currentUser.id! == item.ownerId) {
        self.ownItem = true
      }
    }
  }
    .edgesIgnoringSafeArea(.bottom)
  }
  
}




