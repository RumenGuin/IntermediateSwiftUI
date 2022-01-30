//
//  ImageLoadingViewModel.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 30/01/22.
//

import Foundation
import SwiftUI
import Combine


class ImageLoadingViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    //toggle between these two to find difference, we don't have to change anything to find diff. between fileM and cacheM
    //let manager = PhotoModelCacheManager.instance
    let manager = PhotoModelFileManager.instance
    
    let urlString: String
    let imageKey: String
    init(url: String, key: String) {
        urlString = url
        imageKey = key
        getImage()
    }
    
    func getImage() {
        // manager.get(key: imageKey) returns UIImage?
        //trying to get image from cache
        if let savedImage = manager.get(key: imageKey) {
            image = savedImage
            print("Getting saved image!")
        }
        //if we dont have the image already in the cache, download image
        else {
            downloadImage()
            print("Downloading Image Now")
        }
    }
    
    func downloadImage() {
       
        isLoading = true
        guard let url = URL(string: urlString) else {
            isLoading = false //if fail to get URL
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map({UIImage(data: $0.data)})
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                self?.isLoading = false
            } receiveValue: {[weak self] returnedImage in
                guard let self = self,
                let image = returnedImage
                else {return}
                self.image = image
                self.manager.add(key: self.imageKey, value: image)
            }
            .store(in: &cancellables)
    }
}
