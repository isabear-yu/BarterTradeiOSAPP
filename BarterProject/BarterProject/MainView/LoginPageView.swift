//
//  LoginPageView.swift
//  BarterProject
//
//  Created by Tzuyu Huang on 10/28/21.
//

import SwiftUI
import DynamicColor
import UIKit
import FirebaseDatabase
import Firebase
import FirebaseFirestore

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)


struct LoginPageView: View {
  
  private let db = Firestore.firestore()
  @ObservedObject var userViewModel = UserViewModel()
  
  @State var username: String = ""
  @State var password: String = ""
  @State var authenticationDidFail: Bool = false
  @State var authenticationDidSucceed: Bool = false
  @State var showRegisterNewUser: Bool = false
  @State var showContentView = false
  @State var currUser = User(id:"", email:"", name:"",ratings:0,username:"", password: "", image: "")
  
  var body: some View {
    NavigationView{
      ZStack{
        VStack {
          WelcomText()
          HStack{
            CMUText()
            MiddleX()
            BarterText()
          }
          TartanImage()
          AndrewId(username: $username)
          Password(password: $password)
          
          if authenticationDidFail {
            Text("Information not correct. Try again.")
              .offset(y: -10)
              .foregroundColor(.shadedColor)
          }
          
          Button(action:{
            authenticateUser()
          }){
            LoginButtonView()
          }
          NavigationLink(destination: MainPageView(currentUser: currUser).navigationBarHidden(true).navigationBarTitleDisplayMode(.inline), isActive: $authenticationDidSucceed) {
            EmptyView()
          }
          
          Button("Register New User") {
            self.showRegisterNewUser = true
          }.sheet(isPresented: $showRegisterNewUser, content: {
            RegisterUserView()
          }).padding()
            .foregroundColor(.gray)
        }
        .padding()
      }
    }
  }
  
  func authenticateUser() {
    var query = db.collection("users").whereField("username", isEqualTo: self.username)
    query = query.whereField("password", isEqualTo: self.password)
    query.getDocuments() { (querySnapshot, err) in
      
      guard let documents = querySnapshot?.documents else {
        self.authenticationDidFail = true
        self.authenticationDidSucceed = false
        return
      }
      
      let all = documents.compactMap { queryDocumentSnapshot in
        try? queryDocumentSnapshot.data(as: User.self)
      }
      if all.count == 1 {
        self.currUser = all[0]
        self.authenticationDidFail = false
        self.authenticationDidSucceed = true
      } else {
        self.authenticationDidFail = true
        self.authenticationDidSucceed = false
      }
    }
  }
}

extension Color {
  static let teal = Color(red: 49 / 255, green: 163 / 255, blue: 159 / 255)
  static let darkPink = Color(red: 208 / 255, green: 45 / 255, blue: 208 / 255)
  
  static let originalColor = DynamicColor(hexString: "#c0392b")
  static let shadedColor = Color(originalColor.shaded())
  
}


struct LoginButtonView: View {
  var body: some View {
    Text("LOGIN")
      .font(.headline)
      .foregroundColor(.white)
      .padding()
      .frame(width: 220, height: 60)
      .background(Color.gray)
      .cornerRadius(35.0)
  }
}

struct WelcomText: View {
  var body: some View {
    Text("Welcome to")
      .font(.title)
      .fontWeight(.semibold)
      .padding(.bottom,10)
      .foregroundColor(.gray)
  }
}

struct CMUText: View {
  var body: some View {
    Text("CMU")
      .font(.largeTitle)
      .fontWeight(.bold)
      .padding(.bottom,20)
      .foregroundColor(.shadedColor)
  }
}

struct MiddleX: View {
  var body: some View {
    Text("x")
      .font(.title)
      .fontWeight(.bold)
      .padding(.bottom,20)
      .foregroundColor(.gray)
  }
}

struct BarterText: View {
  var body: some View {
    Text("Barter")
      .font(.largeTitle)
      .fontWeight(.bold)
      .padding(.bottom,20)
      .foregroundColor(.yellow)
  }
}

struct TartanImage: View {
  var body: some View {
    Image("tartans")
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      .clipped()
      .cornerRadius(150)
      .padding(.bottom,50)
  }
}

struct AndrewId: View {
  @Binding var username: String
  var body: some View {
    TextField("Username",text: $username )
      .padding()
      .background(lightGreyColor)
      .cornerRadius(5.0)
      .padding(.bottom,20)
      .autocapitalization(.none)
      .disableAutocorrection(true)
  }
}

struct Password: View {
  @Binding var password: String
  var body: some View {
    SecureInputView("Password", text:$password)
      .padding()
      .background(lightGreyColor)
      .cornerRadius(5.0)
      .padding(.bottom,20)
      .autocapitalization(.none)
      .disableAutocorrection(true)
  }
}

