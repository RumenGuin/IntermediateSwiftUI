//
//  CacheBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 23/01/22.
//

import SwiftUI

class CacheManager {
    static let instance = CacheManager() //singleton(only instance of our cachemanager)
    private init() { }//becoz we're making the init private, it'll tell xcode we can only initialize a CacheManager within the class
    
    
    //when we have any kind of data(relevant for images), when we download from the internet, if we don't want to save them permanently to the file manager or to core data we can add a cache like this (var imageCache) and this is just a temporary var where we are storing a bunch of images.
    //So if we downloaded this image from internet and we threw it into the cache and then we went to another screen and then maybe the user came back to this screen, instead of just immediately downloading from the internet, we should first check this cache(imageCache) and see if we already had an image with this name and if we had a image with this name then we would just use this local image(imageCache) and not download it again but if of course it wasn't in the cache we would then go and download it.
    var imageCache: NSCache<NSString, UIImage> = {   //<key, Value>
        let cache = NSCache<NSString, UIImage>() //we are doing this to customize
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100 //100mb
        return cache
    }()
    
    func add(image: UIImage, name: String) -> String {
        imageCache.setObject(image, forKey: name as NSString)
        return "Added to cache"
    }
    
    func remove(name: String) -> String {
        imageCache.removeObject(forKey: name as NSString)
        return "remove from cache"
    }
    
    func get(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
}

class CacheViewModel: ObservableObject {
    @Published var startingImage: UIImage? = nil
    @Published var cachedImage: UIImage? = nil
    @Published var infoMessage: String = ""
    let imageName: String = "memo2"
    let manager = CacheManager.instance
    init() {
        getImageFromAssetsFolder()
    }
    func getImageFromAssetsFolder() {
        startingImage = UIImage(named: imageName)
    }
    
    func saveToCache() {
        guard let image = startingImage else {return}
            infoMessage = manager.add(image: image, name: imageName)
    }
    
    func removeFromCache() {
       infoMessage = manager.remove(name: imageName)
    }
    
    func getFromCache() {
        if let returnedImage = manager.get(name: imageName) {
            cachedImage = returnedImage
            infoMessage = "Got image from Cache"
        }else {
            infoMessage = "Image not found in Cache"
        }
        //cachedImage = manager.get(name: imageName)
    }
}

struct CacheBootcamp: View {
    @StateObject var vm = CacheViewModel()
    var body: some View {
        NavigationView {
            VStack {
                if let image = vm.startingImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                
                Text(vm.infoMessage)
                    .font(.headline)
                    .foregroundColor(.purple)
                
                HStack {
                    Button {
                        vm.saveToCache()
                    } label: {
                        Text("Save to Cache")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(.blue)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        vm.removeFromCache()
                    } label: {
                        Text("Delete from Cache")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(.red)
                            .cornerRadius(10)
                    }
                }
                Button {
                    vm.getFromCache()
                } label: {
                    Text("Get from Cache")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .padding(.horizontal)
                        .background(.green)
                        .cornerRadius(10)
                }
                
                if let image = vm.cachedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(10)
                }

                
                Spacer()
                
            }
            .navigationTitle("Cache Bootcamp")
        }
    }
}

struct CacheBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CacheBootcamp()
    }
}
