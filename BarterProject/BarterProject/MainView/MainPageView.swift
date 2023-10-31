//
//  MainPageView.swift
//  BarterProject
//
//  Created by Tzuyu Huang on 10/30/21.
//
import SwiftUI
import Foundation
import CoreLocation

struct MainPageView: View {
  
  
  @State var currentUser: User
  @State var landmark: Landmark?
  @ObservedObject var itemViewModel = ItemViewModel()
  @State var searchText: String = ""

  var body: some View{
    ZStack{
      VStack(alignment: .leading){
        
        MainPageBar()
        
        SearchBar(search: $searchText)
        GreetingMsg(currentUser: $currentUser)
        Spacer()
        HStack {
          Text("Your Location:")
            .foregroundColor(Color.shadedColor)
            .fontWeight(.semibold)
            .padding(.leading)
            .padding(.bottom)
          
          NavigationLink(destination: LocationPickerView(landmark: $landmark).navigationBarTitle("Select Location",displayMode: .automatic)) {
            Text(locationText())
              .foregroundColor(.gray)
              .fontWeight(.semibold)
              .padding(.bottom)
          }
        }
        
        
        Text ("Marketplace Items")
          .foregroundColor(Color.shadedColor)
          .fontWeight(.bold)
          .font(.title2)
          .padding(.leading)
        
        
        //Item List
        ScrollView {
          ForEach(itemViewModel.items.filter({ searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased()) })) { item in
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
          .onAppear() {
            self.itemViewModel.subscribe(currentUser: currentUser)
          }
            
        }
        .padding()   
      }
      MenuView(currentUser: currentUser, currentView: "main")
    }
    
  }
  
  func locationText() -> String {
    return landmark == nil ? "Select Location" : landmark!.name
  }
}


struct MainPageBar: View {
  var body: some View {
    HStack{
      Image("main")
        .padding(.bottom,5)
      Text("Main")
        .font(.title)
        .fontWeight(.semibold)
        .padding(.bottom,5)
        .foregroundColor(.shadedColor)
      Text("Page")
        .font(.title)
        .fontWeight(.semibold)
        .padding(.bottom,5)
        .foregroundColor(.gray)
    }
    .padding(.horizontal)
    .padding(.top)
  }
}

struct SearchBar: View {
  @Binding var search: String
  var body: some View {
    HStack{
      Image("search1")
        .padding(.trailing, 8)
      TextField("Search", text: $search)
    }
    .padding()
    .background(lightGreyColor)
    .cornerRadius(10.0)
    .padding(.horizontal)
  }
}

struct GreetingMsg: View {
  @Binding var currentUser: User
  var body: some View {
    HStack {
      Text("Hello " + currentUser.name + " !")
        .foregroundColor(Color.shadedColor)
        .fontWeight(.semibold)
    }
    .padding(.horizontal)
    .padding(.top)
  }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
    }
    
}
