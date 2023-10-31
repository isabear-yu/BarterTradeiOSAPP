//
//  LocationPickerView.swift
//  CMUBarterProject
//
//  Created by Claudia Chua on 2/11/21.
//
import SwiftUI
import MapKit

struct LocationPickerView: View {
  
  @State private var landmarks: [Landmark] = [Landmark]()
  @State private var search: String = ""
  @Binding var landmark: Landmark?
  
  
  private func getNearByLandmarks() {
    
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = search
    
    let search = MKLocalSearch(request: request)
    search.start { (response, error) in
      if let response = response {
        
        let mapItems = response.mapItems
        self.landmarks = mapItems.map {
          Landmark(placemark: $0.placemark)
        }
      }
    }
    
  }
  
  @Environment(\.presentationMode) var presentationMode
  var body: some View {
    VStack(alignment: .leading) {
      TextField("Search", text: $search, onEditingChanged: { _ in })
      {
        // commit
        self.getNearByLandmarks()
      }.textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      List {
        ForEach(self.landmarks, id: \.id) { landmark in
          VStack(alignment: .leading) {
            Text(landmark.name)
              .fontWeight(.bold)
            Text(landmark.title)
          }.onTapGesture {
            self.landmark = landmark
            self.presentationMode.wrappedValue.dismiss()
          }
        }
      }
    }
  }
}
