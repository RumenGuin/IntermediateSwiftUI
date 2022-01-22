//
//  AdvancedCombineBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 22/01/22.
//
// Combine -> Apple's new “reactive” framework for handling events over time.
import SwiftUI
import Combine

class AdvancedCombineDataService {
    //@Published var basicPublisher: String = "first published"
//    let currentValuePublisher = CurrentValueSubject<Int, Error>("1st published") //hold a current value
    let passThroughPublisher = PassthroughSubject<Int, Error>() //does not hold a current value
    //passThroughPublisher, boolPublisher are more memory efficient
    let boolPublisher = PassthroughSubject<Bool, Error>()
    let intPublisher = PassthroughSubject<Int, Error>()
    init() {
        publishFakeData()
    }
    private func publishFakeData() {
        let items: [Int] = Array(1..<11)
        //x == index, index starts from 0
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)) {
                self.passThroughPublisher.send(items[x])
                if (x > 4 && x < 8) {
                    self.boolPublisher.send(true)
                    self.intPublisher.send(999) //output only run after index = 5
                }else {
                    self.boolPublisher.send(false)
                }
                
            //self.basicPublisher = items[x]

                //once this completion gets published the subscriber would then know that the last thing that got published was the value right before we got that completion.
                if x == items.indices.last { //to make .last() know when we are going to stop subscribing
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
        //debounce eg.
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//            self.passThroughPublisher.send(1)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.passThroughPublisher.send(2)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.passThroughPublisher.send(3)
//        }
    }
}


class AdvancedCombineBootcampViewModel: ObservableObject {
    @Published var data: [String] = []
    @Published var dataBools: [Bool] = []
    @Published var error: String = ""
    let dataService = AdvancedCombineDataService()
    var cancellables = Set<AnyCancellable>()
    let multiCastPublisher = PassthroughSubject<Int, Error>()
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
       // dataService.passThroughPublisher
        
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
        /*
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
            //.removeDuplicates() //remove duplicate publish BUT the publiseh has to be BACK TO BACK
            //.removeDuplicates(by: {$0 == $1})
            //.tryRemoveDuplicates(by: <#T##(Int, Int) throws -> Bool#>)
            //.replaceNil(with: 5) //if array is optional and has nil values it will replace it with 5(ANY)
           // .replaceEmpty(with: [])
            //.replaceError(with: 3) //replace error with default value
//            .scan(0, { oldValue, newValue in //scaning previous publish value
//                return oldValue + newValue // 1((oldValue=0) + 1),3(1+2),6(3+3),10(6+4)...,55(1+2+...10)
//            })
            //.scan(0, {$0 + $1})
            //.scan(0, +) // magic
            //.tryScan(<#T##initialResult: T##T#>, <#T##nextPartialResult: (T, Int) throws -> T##(T, Int) throws -> T#>)
            //.reduce(0, +) //55(1+2+3+...10) sum all published values and gives the end result only
           // .allSatisfy({$0 < 50}) //(true) because all values are less than 50 (1...10)
            //.tryAllSatisfy(<#T##predicate: (Int) throws -> Bool##(Int) throws -> Bool#>)
        */
        
        //Timing operation
        /*
           // .debounce(for: 0.75, scheduler: DispatchQueue.main) //its only going to publish a value through here if there at least 0.75 sec between each of the publishes
            //.delay(for: 5, scheduler: DispatchQueue.main) //delays 5 sec before publishing the 1st value
//            .measureInterval(using: DispatchQueue.main) //for debugging (time between each publishes)
//            .map({ stride in
//                return "\(stride.timeInterval)"
//            })
           // .throttle(for: 10, scheduler: DispatchQueue.main, latest: false) // after 1 publish, wait for 10 sec and then output the latest(10) if latest is true. if latest is false, it will publish 2 after 10 sec then 3 after 10 sec..like that
            //.retry(3) //if publisher coming back with error retry again instead of going into the completion
            //.timeout(0.75, scheduler: DispatchQueue.main) //if we dont get a publisher within 0.75 sec we are gonna consider this publisher to fail and we will stop listening(terminates publishing if exceed the time interval)
        */
        
        //Multiple Publishers/Subscribers
        /*
  //          .combineLatest(dataService.boolPublisher, dataService.intPublisher)
//            .compactMap({ int, bool in
//                if bool {
//                    return String(int)
//                }
//                return nil
//            })
           // .compactMap({$1 ? String($0) : "n/a"}) //$1 == bool, $0 == int
            //.removeDuplicates()
        //this code below only run after intPublisher publishes on 5th index
//            .compactMap({ int1, bool, int2 in
//                if bool {
//                    return "\(int1)" //output only run after index = 5 as intPublisher only publishes on 5th index
//                }
//                return "n/a"
//            })
        
        
        //    .merge(with: dataService.intPublisher) //both publishers must emit the same values (Int here)
//            .zip(dataService.boolPublisher, dataService.intPublisher)
//            .map({ tuple in
//                return "\(tuple.0)" + tuple.1.description + "\(tuple.2)" //0,2 == int
//            })
//            .tryMap({ int in
//                if int == 5 {
//                    throw URLError(.badServerResponse) //instead of throwing error we are catching error with .catch
//                }
//                return int
//            })
//            .catch({ error in
//                return self.dataService.intPublisher // instead of error we are returning 999(intPublisher)
//            })
        
        */
        
        
        
        let sharedPublisher = dataService.passThroughPublisher
           // .dropFirst(3)
            .share()
//            .multicast {
//                PassthroughSubject<Int,Error>()
//            }
            .multicast(subject: multiCastPublisher)
        
        sharedPublisher
        
            .map({String($0)})
            //.collect() //collect all data from publisher and put on the screen at ONE time (Imp)
            //.collect(3) //collect 3 data at a time and put on the screen, and we are appending else it will not append automatically
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = "ERROR: \(error.localizedDescription)"
                }
            } receiveValue: {[weak self] returnedValue in
               // guard let self = self else {return}
                //this is asynchronous code, so this is not returning immediately but whenever these values come back, so self is strong reference to this class hence we're going to make weak reference by using weak self
                //self.data.append(contentsOf: returnedValue) //.collect(3)
                //self.data = returnedValue //.collect()
                self?.data.append(returnedValue)
            }
            .store(in: &cancellables)
        
        
        
        sharedPublisher
        
            .map({$0 > 5 ? true : false})
            
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = "ERROR: \(error.localizedDescription)"
                }
            } receiveValue: {[weak self] returnedValue in
                self?.dataBools.append(returnedValue)
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            sharedPublisher
                .connect() //delay connecting to publishers (with .share() and .multicast)
                .store(in: &self.cancellables)
        }

    }
    
}

struct AdvancedCombineBootcamp: View {
    @StateObject private var vm = AdvancedCombineBootcampViewModel()
    var body: some View {
        ScrollView {
            HStack {
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
                
                VStack {
                    ForEach(vm.dataBools, id: \.self) {
                        Text($0.description)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                   
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
