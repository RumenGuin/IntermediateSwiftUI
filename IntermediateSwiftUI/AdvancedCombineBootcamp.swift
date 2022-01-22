//
//  AdvancedCombineBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 22/01/22.
//

import SwiftUI
import Combine

class AdvancedCombineDataService {
    //@Published var basicPublisher: String = "first published"
//    let currentValuePublisher = CurrentValueSubject<Int, Error>("1st published") //hold a current value
    let passThroughPublisher = PassthroughSubject<Int, Error>() //does not hold a current value
    //passThroughPublisher is more memory efficient
    init() {
        publishFakeData()
    }
    private func publishFakeData() {
        let items: [Int] = Array(1..<11)
        
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)) {
                self.passThroughPublisher.send(items[x])
            //self.basicPublisher = items[x]
                
                //once this completion gets published the subscriber would then know that the last thing that got published was the value right before we got that completion.
                if x == items.indices.last { //to make .last() know when we are going to stop subscribing
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
    }
}


class AdvancedCombineBootcampViewModel: ObservableObject {
    @Published var data: [String] = []
    @Published var error: String = ""
    let dataService = AdvancedCombineDataService()
    var cancellables = Set<AnyCancellable>()
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService.passThroughPublisher
        
            //sequence operations
        /*
            .first()  //only the first publshed value by publisher
            .first(where: {$0 > 4}) //return the first published value greater than 4 i.e 5
         //.try to throw error
            .tryFirst(where: { int in
                if int == 3 {
                    throw URLError(.badServerResponse)
                }
             //   return int > 4 //return nothing because we're throwing error if int ==3 and returning only when int > 4
                return int > 1 //return 2 on screen, no error
            })
        
        
            .last() //last value gets published before the completion came through
            .last(where: {$0 > 4}) //last item greater than 4 i.e 10 here
            .tryLast(where: { int in
                if int == 3{
                    throw URLError(.badServerResponse)
                }
                return int > 1 //error (although it hits 2 but then it get error completion, so we get error)
            })
        
        
            .dropFirst() // useful if we use normal @Published or currentValuePublisher because we may want to drop out(cancel/remove) the first published value (here "first published")
            .dropFirst(3) //drop/remove first 3 publishes (1,2,3 will not get published)
            .drop(while: {$0 < 5}) //drop/remove 1,2,3,4 (drop every element less than 5, used in beginning, not at end)
            .tryDrop(while: { int in
                if int == 15 {
                    throw URLError(.badServerResponse)
                }
                return int < 6 //6,7,8,9,10
            })
        
        
            .prefix(4) //first 4 publishes (1,2,3,4)
            .prefix(while: {$0 < 5}) //publish value less than 5 (1,2,3,4)
            .tryPrefix(while: { int in
                if int == 5 {
                    throw URLError(.badServerResponse)
                }
                return int < 4 //1,2,3 because it never enter 5
            })
        
        
            .output(at: 1) // gives only the published value at index, (here first index = value is 2)
            .output(in: 2..<4) //indexes 2 and 3 i.e value = 3,4
        
            */
        
        //Mathematics Operations
        /*
            //.max() //publishes the max value (here 10) needs completion
            //.max(by: {$0 > $1}) //1
//            .tryMax(by: { <#Int#>, <#Int#> in
//                <#code#>
//            })
        
        
            //.min() //1
            //.min(by: <#T##(Int, Int) -> Bool#>)
            //.tryMin(by: <#T##(Int, Int) throws -> Bool#>)
        */
        
        //filtering/ Reducing Operations
        
           // .map({String($0)})
//            .tryMap({ int in
//                if int == 5 {
//                   throw URLError(.badServerResponse)
//                }
//                return String(int) // 1,2,3,4 then we get error(we are getting 1 to 4)
//            })
//            .compactMap({ int in //if something doesnt work we can ignore that value, (return nil)
//                if int >= 5 {
//                    return nil
//                }
//                return  "\(int)"//String(int) // 1,2,3,4, NO ERROR becoz from 5 to 10 everything is nil
//            })
            //.tryCompactMap(<#T##transform: (Int) throws -> T?##(Int) throws -> T?#>) //if we want to throw error
            //.filter({$0 > 3 && $0 < 7}) //4,5,6
            //.tryFilter(<#T##isIncluded: (Int) throws -> Bool##(Int) throws -> Bool#>)
            //.removeDuplicates() //remove duplicate publish BUT the publiseh has to be back to back
            //.removeDuplicates(by: {$0 == $1})
            //.tryRemoveDuplicates(by: <#T##(Int, Int) throws -> Bool#>)
        
        
            .map({String($0)})
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = "ERROR: \(error.localizedDescription)"
                }
            } receiveValue: {[weak self] returnedValue in
                //this is asynchronous code, so this is not returning immediately but whenever these values come back, so self is strong reference to this class hence we're going to make weak reference by using weak self
                self?.data.append(returnedValue)
            }
            .store(in: &cancellables)

    }
    
}

struct AdvancedCombineBootcamp: View {
    @StateObject private var vm = AdvancedCombineBootcampViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.data, id: \.self) {
                    Text($0)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                if !vm.error.isEmpty {
                    Text(vm.error)
                }
            }
        }
    }
}

struct AdvancedCombineBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineBootcamp()
    }
}
