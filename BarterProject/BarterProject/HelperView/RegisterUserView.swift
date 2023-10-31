//
//  RegisterUserView.swift
//  BarterProject
//
//  Created by Claudia Chua on 18/11/21.
//

import SwiftUI
import UIKit

struct RegisterUserView: View {
  
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  var userViewModel = UserViewModel()
  
  @State var name: String = ""
  @State var email: String = ""
  @State var username: String = ""
  @State var password: String = ""
  
  @State var showImagePicker: Bool = false
  @State var image: UIImage? = nil
  
  @State var showUsernameWarning = false
  @State var showEmailWarning = false

  var displayImage: Image? {
    if let picture = image {
      return Image(uiImage: picture)
    } else {
      return Image("profilepic")
    }
  }
  
  var body: some View {
    VStack {
      
      HStack{
        Image("profile")
          .padding(.bottom,5)
        Text("Sign Up")
          .font(.title)
          .fontWeight(.semibold)
          .padding(.bottom,5)
          .foregroundColor(.shadedColor)
      }
      .padding(.horizontal)
      .padding(.top)
      
      Group {
        displayImage?
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 200.0, height: 200.0)
          .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 3).shadow(radius: 10))
        
        Button(action: {
          self.showImagePicker = true
        }) {
          Text(buttonText())
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
          Text("Email has been registered")
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
            self.userViewModel.addNewUser(image: image, name: name, email: email, username: username, password: password)
            self.mode.wrappedValue.dismiss()
      }) {
        Text("Register").fontWeight(.semibold).padding()
      }.frame(maxWidth:.infinity)
        .disabled(isFieldInvalid)
        .background(registerButtonColor)
        .foregroundColor(.white)
    }
    .sheet(isPresented: $showImagePicker) {
      PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
    }
  }
  
  
  var isFieldInvalid: Bool {
    return username.isEmpty || email.isEmpty || password.isEmpty || name.isEmpty || showEmailWarning || showUsernameWarning
  }
  
  var registerButtonColor: Color {
    return isFieldInvalid ? Color.gray : Color.shadedColor
  }

  
  func buttonText() -> String {
    return image == nil ? "Add Profile Picture" : "Change Profile Picture"
  }
}

