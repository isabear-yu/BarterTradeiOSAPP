//
//  UploadItemView.swift
//  BarterProject
//
//  Created by Tzuyu Huang on 11/5/21.
//

import SwiftUI
import UIKit
import CoreLocation
import MapKit
import FirebaseFirestore

struct UploadItemView: View {
    
  @Environment(\.presentationMode) var mode: Binding<PresentationMode>
  
  var itemViewModel = ItemViewModel()
  
  @State var currentUser: User
  @State var name: String = ""
  @State var condition: String = ""
  @State var desc: String = ""
  @State var landmark: Landmark?
  
  @State var showImagePicker: Bool = false
  @State var image: UIImage?
  
  var conditions = ["New","Used"]
  
  var displayImage: Image? {
    if let picture = image {
      return Image(uiImage: picture)
    } else {
      return Image("placeholder")
    }
  }
  
  
  var body: some View{
    
    VStack(alignment: .leading){
      
      HStack{
        Image("upload")
          .padding(.bottom,5)
        Text("Create")
          .font(.title)
          .fontWeight(.semibold)
          .padding(.bottom,5)
          .foregroundColor(.shadedColor)
        Text("Post")
          .font(.title)
          .fontWeight(.semibold)
          .padding(.bottom,5)
          .foregroundColor(.gray)
      }
      .padding(.top)
      .padding(.horizontal)
    
      Group {
        HStack {
          Text("Name:")
            .fontWeight(.bold)
          TextField("Item Name", text: $name)
            .padding(.trailing)
        }.padding()
        Divider()
      }
      
      Group {
        HStack {
          Text("Condition:")
            .fontWeight(.bold)
          Picker("Condition: ", selection: $condition) {
            ForEach(conditions, id: \.self) {
              Text($0)
            }
          }.pickerStyle(SegmentedPickerStyle())
        }.padding()
        Divider()
      }
      
      Group {
        HStack {
          Text("Trade Location:")
            .fontWeight(.bold)
          NavigationLink(destination: LocationPickerView(landmark: $landmark).navigationBarTitle("Select Location",displayMode: .automatic)) {
            Text(locationText())
              .foregroundColor(Color.shadedColor)
              .fontWeight(.semibold)
          }
          Spacer()
        }.padding()
        Divider()
      }
      
      Group {
        VStack(alignment: .leading) {
          Text("Description:")
            .fontWeight(.bold)
          
          TextEditor(text: $desc)
            .frame(height: 75)
            .textFieldStyle(PlainTextFieldStyle())
        }.padding()
        Divider()
      }
      
      Spacer()
      Group {
        HStack{
          Spacer()
          displayImage?.resizable().scaledToFit()
            .frame(width: 150.0, height: 150.0)
          Spacer()
        }
        
        Button(action: {
          self.showImagePicker = true
        }) {
          HStack{
            Spacer()
            Text(buttonText())
              .fontWeight(.semibold)
              .padding(.bottom,10)
            Spacer()
          }
        }.foregroundColor(Color.shadedColor)
        
        Button(action: {
          addItem()
          self.mode.wrappedValue.dismiss()
        }) {
          Text("Done").fontWeight(.semibold).padding()
        }.frame(maxWidth:.infinity, alignment: .bottom)
          .background(Color.shadedColor)
          .foregroundColor(.white)
      }
      MenuView(currentUser: currentUser, currentView: "upload")
    }
    .sheet(isPresented: $showImagePicker) {
      PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
    }

  }
  
  func buttonText() -> String {
    return image == nil ? "Add Item Picture" : "Change Item Picture"
  }
  
  func locationText() -> String {
    return landmark == nil ? "Select Location" : landmark!.name
  }
  
  func addItem() {
    self.itemViewModel.addItemToFirebase(image: self.image, name: self.name, condition: self.condition, description: self.desc, landmark: self.landmark, user: self.currentUser)
  }
  
  
}

