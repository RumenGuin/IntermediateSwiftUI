//
//  UnitTestingViewModel.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 25/01/22.
//

import Foundation
import SwiftUI
import Combine


class UnitTestingBootcampViewModel: ObservableObject {
    @Published var isPremium: Bool
    @Published var dataArray: [String] = []
    @Published var selectedItem: String? = nil
    let dataService: NewDataServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
    init(isPremium: Bool, dataService: NewDataServiceProtocol = NewMockDataService(items: nil)) {
        self.isPremium = isPremium
        self.dataService = dataService
    }
    
    func addItem(item: String) {
        guard !item.isEmpty else {return}
        self.dataArray.append(item)
    }
    
    func selectItem(item: String) {
        if let x = dataArray.first(where: {$0 == item}) {
            selectedItem = x
        } else {
            selectedItem = nil
        }
    }
    
    func saveItem(item: String) throws {
        
        guard !item.isEmpty else {
            throw DataError.noData //if empty("") throw this error
        }
        
        if let x = dataArray.first(where: {$0 == item}) {
            print("Save Item Here!! \(x)")
        } else {
           throw DataError.itemNotFound
        }
        
    }
    
    enum DataError: LocalizedError {
        case noData
        case itemNotFound
    }
    
    func downloadWithEscaping() {
        dataService.downloadItemsWithEscaping {[weak self] returnedItems in
            self?.dataArray = returnedItems
        }
    }
    
    func downloadWithCombine() {
        dataService.downloadItemsWithCombine()
            .sink { _ in
                
            } receiveValue: {[weak self] returnedItems in
                self?.dataArray = returnedItems
            }
            .store(in: &cancellables)

    }
}
