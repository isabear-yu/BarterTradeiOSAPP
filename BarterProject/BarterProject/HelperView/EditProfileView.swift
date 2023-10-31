//
//  EditProfileView.swift
//  BarterProject
//
//  Created by Claudia Chua on 2/12/21.
//

import SwiftUI

struct EditProfileView: View {
  
  var currentUser: User
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  @ObservedObject var userViewModel = UserViewModel()
  @State var showImagePicker: Bool = false
  @State var image: UIImage? = nil
  
  @State var name: String = ""
  @State var email: String = ""
  @State var username: String = ""
  @State var password: String = ""
  
  @State var showUsernameWarning = false
  @State var showEmailWarning = false
  
  var body: some View {
    
    VStack {
      HStack{
        Image("profile")
          .padding(.bottom,5)
        Text("Edit Profile")
          .font(.title)
          .fontWeight(.semibold)
          .padding(.bottom,5)
          .foregroundColor(.shadedColor)
      }
      .padding(.horizontal)
      .padding(.top)
      
      Group {
        
        FirebaseEditProfileImage(id: currentUser.image!)
        
        Button(action: {
          self.showImagePicker = true
        }) {
          Text("Change Profile Picture")
        }.padding()
      }
      
      Group {
        HStack {
          Text("name:")
            .fontWeight(.bold)
            .padding(.leading)
          TextField("full name", text: $name)
            .disableAutocorrection(true)
            .padding(.trailing)
        }.padding()
        
        Divider()
        
        HStack {
          Text("email:")
            .fontWeight(.bold)
            .padding(.leading)
          TextField("email", text: $email, onEditingChanged: { (isBegin) in
            if !isBegin {
              userViewModel.emailExist(email: email) { (res) in
                self.showEmailWarning = res
              }
            }
          })
            .keyboardType(.emailAddress)
            .textCase(.lowercase)
            .padding(.trailing)
            .autocapitalization(.none)
            .disableAutocorrection(true)
          
        }.padding()
        if showEmailWarning {
          Text("Email has been used")
            .offset(y: -10)
            .foregroundColor(.shadedColor)
        }
        Divider()
        
        HStack {
          Text("username:")
            .fontWeight(.bold)
            .padding(.leading)
          TextField("username", text: $username, onEditingChanged: { (isBegin) in
            if !isBegin {
              userViewModel.usernameExist(username: username) { (res) in
                self.showUsernameWarning = res
              }
            }
          })
            .padding(.trailing)
            .autocapitalization(.none)
            .disableAutocorrection(true)
          
        }.padding()
        if showUsernameWarning {
          Text("Username has been taken. Try another?")
            .offset(y: -10)
            .foregroundColor(.shadedColor)
        }
        Divider()
        HStack {
          Text("password:")
            .fontWeight(.bold)
            .padding(.leading)
          SecureInputView("password", text: $password)
            .padding(.trailing)
            .disableAutocorrection(true)
        }.padding()
      }
      
      Spacer()
      
      Button(action: {
        let newProfile = User(email: email, name: name, ratings: currentUser.ratings, username: username, password: password, image: "")
        
        self.userViewModel.updateUser(currentProfile: currentUser, newProfile: newProfile)
        
        self.mode.wrappedValue.dismiss()
      }) {
        Text("Save").fontWeight(.semibold).padding()
      }.frame(maxWidth:.infinity)
        .disabled(isFieldInvalid)
        .background(saveButtonColor)
        .foregroundColor(.white)
    }
    .onAppear {
      self.name = currentUser.name
      self.username = currentUser.username
      self.email = currentUser.email
      self.password = currentUser.password
    }
    .sheet(isPresented: $showImagePicker) {
      PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
    }
  }
  
  var isFieldInvalid: Bool {
    return username.isEmpty || email.isEmpty || password.isEmpty || name.isEmpty || showEmailWarning || showUsernameWarning
  }
  
  var saveButtonColor: Color {
    return isFieldInvalid ? Color.gray : Color.shadedColor
  }

}


