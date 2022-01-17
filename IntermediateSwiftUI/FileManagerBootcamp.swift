//
//  FileManagerBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 16/01/22.
//

import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    let folderName = "MyApp_Images"
    init() {
        createFolderIfNeeded()
    }
    
    func createFolderIfNeeded() {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
                    return
                }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("success creating folder")
            } catch let error {
                print("Error creating folder \(error)")
            }
        }
    }
    
    func deleteFolder() {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .path else {
                    return
                }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Success deleting folder")
        } catch let error {
            print("error deleting folder \(error)")
        }
    }
    
    func saveImage(image: UIImage, name: String) -> String{
        
        
       guard
        let data = image.jpegData(compressionQuality: 1.0),
        let path = getPathForImage(name: name) else {
            return "Error getting data"
            
        }
      
        //where to we want to save the data
        do {
            try data.write(to: path)
            print(path)
            return "success saving"
        } catch let error {
            return "Error saving \(error)"
        }
    }
    
    func retrievedImage(name: String) -> UIImage? {
        guard
            let path = getPathForImage(name: name)?.path, //we have to convert url to string
            FileManager.default.fileExists(atPath: path) else {
                print("error geting path")
                return nil
            }
        
        return UIImage(contentsOfFile: path)
                
    }
    
    func deleteImage(name: String) -> String{
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
                return "error geting path"
                
            }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return "delete successful"
        } catch let error {
            return "error deleting image \(error)"
        }
        
    }
    
    func getPathForImage(name: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName)
                .appendingPathComponent("\(name).jpg") else {
                    print("Error getting path")
                    return nil
                }
        return path
    }
    
}

class FilemanagerViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let imageName: String = "Boarding"
    let manager = LocalFileManager.instance
    @Published var infoMessage: String = ""
    
    init() {
        getImageFromAssetFolder()
        //retrievedImageFromFileManager()
    }
    func getImageFromAssetFolder() {
        image = UIImage(named: imageName)
    }
    
    func retrievedImageFromFileManager() {
        image = manager.retrievedImage(name: imageName)
    }
    
    func saveImage() {
        guard let image = image else {return}
        infoMessage = manager.saveImage(image: image, name: imageName)
    }
    
    func deleteImage() {
        infoMessage = manager.deleteImage(name: imageName)
        manager.deleteFolder()
    }
}

struct FileManagerBootcamp: View {
    @StateObject var vm = FilemanagerViewModel()
    var body: some View {
        NavigationView {
            VStack {
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipped()
                    .cornerRadius(10)
                }
                VStack {
                    Button {
                        vm.saveImage()
                    } label: {
                        Text("Save to File Manager ")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(.blue)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        vm.deleteImage()
                    } label: {
                        Text("Delete from File Manager ")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(.red)
                            .cornerRadius(10)
                    }
                }
                
                Text(vm.infoMessage)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)

                
                Spacer()
                
            }
            .navigationTitle("File Manager")
        }
    }
}

struct FileManagerBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerBootcamp()
    }
}
