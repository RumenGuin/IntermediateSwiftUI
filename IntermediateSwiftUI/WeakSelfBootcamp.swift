//
//  WeakSelfBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 05/01/22.
//

import SwiftUI

/* In Simulator
 tapped Navigate -> Initialize now
 back to screen 1 and tapped Navigate again -> Initialize new one and deinitialize the first one.
 Initializing and deinitializing every time.
 count = 1 always
 
 But when we use strong reference (self.data) count increases by 1 everytime because everytime its initializing. After 500 sec(here for eg.) it will deinitialize.
 
 [weak self] -> we DO NOT need this class to stay alive
 count = 1 always initialize and deinitialize
 
 
 If you are downloading data for the 2nd screen(here) and then the user moves to another screen we do not need that 2nd screen to stay alive anymore. if it will stay alive it will tak up memory, slow down application which is not efficient.
 
 By using [weak self] we can make references to classes and to self OPTIONAL
 We are telling xcode that it's OK if this class deinitializes because if we use strong reference we are telling xcode that we absolutely need this class to stay alive
 
 */

struct WeakSelfBootcamp: View {
    @AppStorage("count") var count: Int?
    init() {
        count = 0
    }
    var body: some View {
        NavigationView {
            NavigationLink("Navigate") {
                WeakSelfSecondScreen()
                    
            }
            .navigationTitle("Screen 1")
        }
        
        .overlay(
        Text("\(count ?? 0)")
            .font(.largeTitle)
            .padding()
            .padding(.horizontal)
            .background(Color.pink.cornerRadius(25)), alignment: .topTrailing
        )
    }
}

struct WeakSelfSecondScreen: View {
    @StateObject var vm = WeakSelfSecondScreenViewModel()
    var body: some View {
        VStack {
            Text("SecondView")
                .font(.largeTitle)
            .foregroundColor(.pink)
            
            if let data = vm.data {
                Text(data)
            }
        }
        
    }
}

class WeakSelfSecondScreenViewModel: ObservableObject {
    @Published var data: String? = nil
    
    init() {
        print("Initialize Now")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        getData()
    }
    
    deinit {
        print("Deinitialize Now")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    func getData() {
            //self.data means creating strong reference -> that is telling system that while this tasks are running this class absolutely need to stay alive because we need that self when we come back
        DispatchQueue.main.asyncAfter(deadline: .now() + 500) { [weak self] in
            self?.data = "New Data"
            //[weak self] -> we DO NOT need this class to stay alive
        }
        
    }
}

struct WeakSelfBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        WeakSelfBootcamp()
    }
}

