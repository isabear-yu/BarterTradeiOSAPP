//
//  ProfilePageView.swift
//  BarterProject
//
//  Created by Claudia Chua on 2/12/21.
//

import SwiftUI

struct ProfilePageView: View {
  
  @State var currentUser: User
  
  @ObservedObject var userViewModel = UserViewModel()
  @ObservedObject var itemViewModel = ItemViewModel()
  @State var currentUserItems = [Item]()
  
    var body: some View {
      
      ZStack {
        VStack(alignment: .leading) {
          //Display Title
          HStack {
            Image("profile2")
              .padding(.bottom,5)
            Text("Profile")
              .font(.title)
              .fontWeight(.semibold)
              .padding(.bottom,5)
              .foregroundColor(.shadedColor)
            Spacer()
            
            NavigationLink(destination: EditProfileView(currentUser:self.currentUser)) {
                Text("Edit")
            }
          }
          .padding(.horizontal)
          .padding(.top)
          
          //User Infomation Bar
          HStack {
            //Display Image
            FirebaseProfileImage(id: currentUser.image!)
        
            VStack(alignment: .leading) {
              //Display Name
              Text(currentUser.name)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom,5)
              //Display Rating
              Text("Ratings: " + String(currentUser.ratings))
                .font(.subheadline)
            }.padding(.horizontal)
          }
          .padding(.horizontal)
          .padding(.top)
          
          //Display Title
          HStack {
            Text("Listed Items")
              .font(.title)
              .fontWeight(.semibold)
              .padding(.bottom,5)
              .foregroundColor(.gray)
          }
          .padding(.horizontal)
          .padding(.top)
          
          //Display User Items
          ScrollView {
            ForEach(currentUserItems) { item in
              HStack{
                  FirebaseItemImage(id: item.img!)
                NavigationLink(destination: ItemDetail(item:item, currentUser: currentUser)) {
                  ItemRow(item:item)
                }
              }
              .padding(10)
              .background(lightGreyColor)
              .modifier(CardModifier())
              .padding(.all, 5)
            }
            .onAppear(perform: loadItems)
              
          }
          .padding()
        }
        MenuView(currentUser: currentUser, currentView: "profile")
      }
    }
  
  func loadItems() {
    
    userViewModel.getUser(userId: currentUser.id!) { (respond) in
      if let updatedUser = respond {
        DispatchQueue.main.async {
          self.currentUser = updatedUser
        }
      }
    }
    
    self.itemViewModel.getOwnItems(userid: currentUser.id!) { (ownItems) in
      if ownItems != nil {
        DispatchQueue.main.async {
          self.currentUserItems = ownItems!
        }
      }
    }
  }
  
}
