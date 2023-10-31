//
//  Landmark.swift
//  BarterProject
//
//  Created by Claudia Chua on 4/11/21.
//

import Foundation
import MapKit

struct Landmark {

  
    let placemark: MKPlacemark
    
    var id: UUID {
        return UUID()
    }
    
    var name: String {
        self.placemark.name ?? ""
    }
    
    var title: String { //address
        self.placemark.title ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
}
