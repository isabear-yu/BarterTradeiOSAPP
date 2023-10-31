//
//  ImageCache.swift
//  BarterProject
//
//  Created by Claudia Chua on 18/11/21.
//

import SwiftUI
import Combine

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(imageId: String) -> UIImage? {
        return cache.object(forKey: NSString(string: imageId))
    }
    
    func set(imageid: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: imageid))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
