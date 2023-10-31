//
//  PhotoCaptureView.swift
//  CMUBarterProject
//
//  Created by Claudia Chua on 29/10/21.
//

import SwiftUI

struct PhotoCaptureView: View {

  @Binding var showImagePicker: Bool
  @Binding var image: UIImage?

  var body: some View {
    ImagePicker(isShown: $showImagePicker, image: $image)
  }
}

