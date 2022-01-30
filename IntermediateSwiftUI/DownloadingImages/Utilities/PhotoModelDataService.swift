//
//  PhotoModelDataService.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 30/01/22.
//

import Foundation
import Combine

class PhotoModelDataService {
    static let instance = PhotoModelDataService() //singleton
    @Published var photoModels: [PhotoModel] = []
    var cancellables = Set<AnyCancellable>()
    
    private init() {
        //as it is private init we are allowed to initialize only inside this class
        downloadData()
    }
    
    func downloadData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {return}
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [PhotoModel].self, decoder: JSONDecoder()) //decode to array of photomodel
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error downloading data: \(error)")
                }
            } receiveValue: {[weak self] returnedPhotoModels in
                self?.photoModels = returnedPhotoModels
            }
            .store(in: &cancellables)

         
    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
        return output.data //if successfull
    }
}
