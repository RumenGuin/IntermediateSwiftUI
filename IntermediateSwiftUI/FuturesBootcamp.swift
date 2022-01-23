//
//  FuturesBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 23/01/22.
//

import SwiftUI
import Combine
//downlaod with combine
//download with @escaping closures
//convert @escaping closure to combine

//we get the asynchronous code with @escaping and we can convert it to a Future publisher that produces one single value

class FuturesBootcampViewModel: ObservableObject {
    
    @Published var title: String = "Starting Title"
    let url = URL(string: "https://www.google.com")!
    var cancellables = Set<AnyCancellable>()
    init() {
        download()
    }
    
    func download() {
       // getCombinePublisher()
        getFuturePublisher()
            .sink { _ in

            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
            .store(in: &cancellables)
        
//        getEscapingClosure {[weak self] returnedValue, error in
//            self?.title = returnedValue
//        }

    }
    
    func getCombinePublisher() -> AnyPublisher<String, URLError>{
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({ _ in
                return "New Value"
            })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHandler: @escaping (_ value: String, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHandler("New Value 2", nil)
        }
        .resume()
    }
    //Future is a publisher that will eventually produce a SINGLE VALUE and then finish or fails.
    //using future for that one value we can use it and subscribe to it.
    //regular publishers keep publishing over their lifetime and we subscribed to them forever
    //Promise is just the function promising that it will return a value in the future
    func getFuturePublisher() -> Future<String, Error> {
        return Future { promise in
            self.getEscapingClosure { returnedValue, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(returnedValue))
                }
            }
        }
    }
    
    
    //we get the asynchronous code with @escaping and we can convert it to a Future publisher that produces one single value
    
    
    func doSomething(completionHandler: @escaping (_ value: String) -> ()){
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completionHandler("new String")
        }
    }
    
    func doSomethingInFuture() -> Future<String, Never> { //this future will never fail
        Future { promise in
            self.doSomething { value in
                promise(.success(value))
            }
        }
    }
}

struct FuturesBootcamp: View {
    @StateObject var vm = FuturesBootcampViewModel()
    var body: some View {
        Text(vm.title)
    }
}

struct FuturesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        FuturesBootcamp()
    }
}
