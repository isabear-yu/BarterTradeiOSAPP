//
//  FirebaseImage.swift.swift
//  BarterProject
//
//  Created by Claudia Chua on 10/11/21.
//


import SwiftUI
import Combine

import FirebaseStorage

final class Loader : ObservableObject {
  
  @Published var image: UIImage?
  var imageCache = ImageCache.getImageCache()
    
  init(_ id: String){
    
    //Search for Cache first
    guard let cacheImage = imageCache.get(imageId: id) else {
      
      //If Image not in Cache -> Search Firebase Storage
      let storage = Storage.storage()
      let ref = storage.reference().child(id)
      ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
        if let error = error {
          print("\(error)")
        }
        
        DispatchQueue.main.async {
          guard let loadedImage = UIImage(data: data!) else {
            return
          }
          self.imageCache.set(imageid: id, image: loadedImage)
          self.image = loadedImage
        }
      }
      return
    }
    self.image = cacheImage
    return
  }
  
}


struct FirebaseItemImage : View {
  
  let placeholder = UIImage(named: "placeholder.jpg")!

  @ObservedObject private var imageLoader : Loader
  
  init(id: String) {
    self.imageLoader = Loader(id)
  }
  
  var body: some View {
    Image(uiImage: imageLoader.image ?? placeholder)
      .resizable()
      .scaledToFit()
      .frame(height: 120)
      .cornerRadius(4)
  }
}

struct FirebaseProfileImage : View {
  
  let placeholder = UIImage(named: "profilepic.jpg")!

  @ObservedObject private var imageLoader : Loader
    
  init(id: String) {
    self.imageLoader = Loader(id)
  }
  
  var body: some View {
    Image(uiImage: imageLoader.image ?? placeholder)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 100.0, height: 100.0)
      .clipShape(Circle())
        .overlay(Circle().stroke(Color.gray, lineWidth: 3).shadow(radius: 10))
  }
}

struct FirebaseEditProfileImage : View {
  
  let placeholder = UIImage(named: "profilepic.jpg")!

  @ObservedObject private var imageLoader : Loader
    
  init(id: String) {
    self.imageLoader = Loader(id)
  }
  
  var body: some View {
    Image(uiImage: imageLoader.image ?? placeholder)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: 200.0, height: 200.0)
      .clipShape(Circle())
        .overlay(Circle().stroke(Color.gray, lineWidth: 3).shadow(radius: 10))
  }
}
