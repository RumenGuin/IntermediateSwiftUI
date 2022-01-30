//
//  PhotoModelFileManager.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 30/01/22.
//

import Foundation
import SwiftUI
//Cool things about FileManager
/*
 Here also we're getting the saved images but this time we're saving them TO THE DEVICE and to the file manager and getting them back from the filemanager they're not being saved in the memory. If I look at memory use (in little spray button/debug area), we see it's 100mb (we're 300mb in Cache). So cache was using so much more memory than the file manager.
 So, Filemanager is more efficent and is better but we don't want to save non-important data to the file manager. We only want to save stuff that is going to be important to the user over and over again, so that we can save it to the device forever.
 
 File Manager is also saving TO THE DEVICE. So, if I close the app and reopen it, we're actually immediately getting these saved images because these images are now saved to the device, they are NOT temporarily saved in the memory.
 
 Eg. If I had something like the user's current profile picture or images on the main screen of my app that every time you open the app you'll see that image, I would put that in the file manager.
 Use File Manager for things that are going to be recurring/repeatedly and super important to the user.
 */

class PhotoModelFileManager {
    static let instance = PhotoModelFileManager() //singleton
    let folderName = "download_photos" //don't put space
    
    private init() {createFolderIfNeeded() }
    
    private func createFolderIfNeeded() {
        
        guard let url = getFolderPath() else {return}
        
        //if the file does not exist, create directory
        if !FileManager.default.fileExists(atPath: url.path) {
            
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("Created Folder")
            }
            catch let error {
                print("Error creating folder: \(error)")
            }
            
        }
    }
    
    private func getFolderPath() -> URL?{
    
        return FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    // folder path ->  ... /download_photos/
    // image path ->  ... /download_photos/image_name.png
    private func getImagePath(key: String) -> URL? {
        guard let folder = getFolderPath() else {
            return nil //if we can't get the folder path we will have to return nil
        }
        return folder.appendingPathComponent(key + ".png")
    }
    
    func add(key: String, value: UIImage) {
        
        guard
            let data = value.pngData(), //Returns a data object that contains the specified image in PNG format.
            let url = getImagePath(key: key) else {return}
        
        do {
            try data.write(to: url)
        }catch let error{
            print("Error saving to File Manger \(error)")
        }
    }
    
    func get(key: String) -> UIImage? {
       
        guard
            let url = getImagePath(key: key),
            FileManager.default.fileExists(atPath: url.path) else {
                return nil
            }
        return UIImage(contentsOfFile: url.path)
                    
    }
}
