//
//  NewMockDataService.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 25/01/22.
//

import Foundation
import Combine
import SwiftUI


protocol NewDataServiceProtocol {
    func downloadItemsWithEscaping(completion: @escaping (_ items: [String]) -> ())
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error>
}

class NewMockDataService: NewDataServiceProtocol {
    let items: [String]
    
    init(items: [String]?) {
        self.items = items ?? [
            "One", "Two", "Three"
        ]
    }
    func downloadItemsWithEscaping(completion: @escaping (_ items: [String]) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(self.items)
        }
    }
    
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error> {
        Just(items)
            .tryMap({ publishedItems in
                guard !publishedItems.isEmpty else {
                    throw URLError(.badServerResponse) //if empty throw error
                }
                return publishedItems
            })
            .eraseToAnyPublisher()
    }
}
