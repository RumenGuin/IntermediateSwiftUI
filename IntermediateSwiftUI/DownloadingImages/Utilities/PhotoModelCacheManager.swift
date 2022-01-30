//
//  PhotoModelCacheManager.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 30/01/22.
//

import Foundation
import SwiftUI

//Cool Things about cache:
/*

1.  We set the totalCostLimit to 200 mb, so about 200mb of this 300mb in memory use (in little spray button/debug area) are in that cache. If memory use ever gets too high, it will automatically start emptying some of the old data.
2.  Cache does not save permanently. They are temporarily saved for that session i.e if I close the app and reopen it I now have to download these images again.
 Conclusion:
-> So, this is very efficient for images that are important to the current session but maybe not important to user forever.
 
 Eg. On instagram, if I go to some random person's profile and I scroll down through their posts, those posts I'm using in this session and I could probably cache them but those posts aren't important enough to me to actually save those on my device bacause I don't need that every time I log into instagram. I only need them on this session when I'm on that's person's profile.

 */

class PhotoModelCacheManager {
    static let instance = PhotoModelCacheManager() //singleton
    private init() {}
    
    var photoCache: NSCache<NSString, UIImage> = {
       var cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200 //The maximum number of objects the cache should hold. (downloading 5K images, hold 200 images)
        cache.totalCostLimit = 1024 * 1024 * 200 //200mb (total amount data that we can put in cache)
        return cache
    }()
    
    func add(key: String, value: UIImage) {
        photoCache.setObject(value, forKey: key as NSString)
    }
    
    func get(key: String) -> UIImage? {
        return photoCache.object(forKey: key as NSString)
    }
    
    
}
