//
//  SubscriberBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 21/01/22.
//
//@Published-> every time its gets updated it publish a value/data
//and then we can subscribe to publisher and listen to publisher, and can update your UI
import SwiftUI
import Combine
class SubscriberViewModel: ObservableObject {
    
    @Published var count: Int = 0
    var cancellables = Set<AnyCancellable>()
    
    @Published var textFieldText: String = ""
    @Published var textisValid: Bool = false
    
    @Published var showButton: Bool = false
    
    init() {
        setUpTimer()
        addTextFieldSubscriber()
        addButtonSubscriber()
    }
    //all subscribing func
    func addTextFieldSubscriber() {
        //anytime textFieldText is changed, we will get published value here
        $textFieldText
        // this debounce will wait 0.5 sec before running rest of the code down here, and its waiting to see if we get another published value
        //if i type quickly here you're gonna see that its not going to filter until it stops receiving values for 0.5 sec (used in textfield to filter)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        //everytime textFieldText(published var) is updated by user, this text(in .map) we'll be receiving from the publisher
            .map { text -> Bool in
                if text.count > 3 {
                    return true
                }
                return false
            }
            //.assign(to: \.textisValid, on: self) (don't use .assign, its using self not weak self)
            .sink(receiveValue: {[weak self] isValid in
                self?.textisValid = isValid
            })
            .store(in: &cancellables)
    }
    
    func setUpTimer() {
         Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink {[weak self] _ in
                //because self? is optional, we first do a check to make sure that self is actually valid because if self is valid we don't need wrtie self?
                //guard let self(a var) = self(weak self)
                guard let self = self else {return}
                self.count += 1
                
//                if self.count >= 10 {
//                    for item in self.cancellables {
//                        item.cancel()
//                    }
//                }
            }
            .store(in: &cancellables)
    }
    
    func addButtonSubscriber() {
        //anytime textIsValid is changed, we will get published value here
        $textisValid
            .combineLatest($count) // we will also get published value from count published var
        //sink is now getting 2 value of type (Bool($textisValid), Int($count))
            .sink {[weak self] isValid, count in
                guard let self = self else {return}
                if isValid && count >= 10 {
                    self.showButton = true
                }else {
                    self.showButton = false
                }
            }
            .store(in: &cancellables)
    }
}

struct SubscriberBootcamp: View {
    @StateObject var vm = SubscriberViewModel()
    var body: some View {
        VStack {
            Text("\(vm.count)")
                .font(.largeTitle)
            
            //Text(vm.textisValid.description)
            
            TextField("Type Something", text: $vm.textFieldText)
                .padding(.leading)
                .frame(height: 55)
                .background(Color.purple.opacity(0.2))
                .cornerRadius(10)
                .overlay(
                    ZStack {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .opacity(
                                vm.textFieldText.count < 1 ? 0 :
                                vm.textisValid ? 0 : 1)
                        
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .opacity(vm.textisValid ? 1 : 0)
                    }
                        .font(.title)
                        .padding(.trailing)
                    , alignment: .trailing
                )
            
            Button {
                
            } label: {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal)
                    .background(.green)
                    .cornerRadius(10)
                    .opacity(vm.showButton ? 1 : 0.5)
            }
            .disabled(!vm.showButton) //if showButton is false we cant even click

        }
        .padding()
    }
}

struct SubscriberBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SubscriberBootcamp()
    }
}
