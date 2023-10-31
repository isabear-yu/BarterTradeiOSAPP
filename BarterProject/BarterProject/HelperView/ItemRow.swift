//
//  ItemRow.swift
//  BarterProject
//
//  Created by Jessie Shao on 11/2/21.
//

import SwiftUI

struct ItemRow: View {
  
  var item:Item
  let width = UIScreen.main.bounds.width * 0.5
  let height = UIScreen.main.bounds.height * 0.02
  
  var body: some View {
    VStack(alignment:.leading, spacing: 5) {
      Text(item.name)
        .font(.system(size: 26, weight: .semibold, design: .default))
        .frame(width: width, height: height, alignment: .leading)
        .padding()
        .minimumScaleFactor(0.5)
        .foregroundColor(Color.black)
    }
  }
}

