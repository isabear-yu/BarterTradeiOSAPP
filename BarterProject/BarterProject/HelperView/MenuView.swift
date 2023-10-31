//
//  NavigationBarView.swift
//  BarterProject
//
//  Created by Claudia Chua on 5/11/21.
//

import SwiftUI

struct MenuView: View {
  
  var currentUser: User
  var currentView: String

  var body: some View {
    
    HStack {

      NavigationLink(destination: MainPageView(currentUser: currentUser).navigationBarHidden(true)) {
        Image("main")
          .frame(maxWidth:.infinity)
      }.disabled(currentView == "main")
      
      NavigationLink(destination: TradePageView(currentUser: currentUser).navigationBarHidden(true)) {
        Image("trade1")
          .frame(maxWidth:.infinity)
      }.disabled(currentView == "trade")
      
      NavigationLink(destination: UploadItemView(currentUser: currentUser).navigationBarHidden(true)) {
        Image("upload")
          .frame(maxWidth:.infinity)
      }.disabled(currentView == "upload")
      
      NavigationLink(destination: ProfilePageView(currentUser:currentUser).navigationBarHidden(true)) {
        Image("profile2")
          .frame(maxWidth:.infinity)
      }.disabled(currentView == "profile")
      
    }
    .padding()
    .background(lightGreyColor)
    .clipShape(Capsule())
    .padding(.horizontal)
    .shadow(color:Color.black.opacity(0.15),radius: 8, x:2, y:6)
    .frame(maxHeight: .infinity, alignment: .bottom)
  }
}

