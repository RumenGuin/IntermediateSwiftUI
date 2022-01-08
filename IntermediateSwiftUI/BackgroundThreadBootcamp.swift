//
//  BackgroundThreadBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 08/01/22.
//

import SwiftUI
/*
 UI stuff -> thread 1 (main thread)
 download data -> thread 10 (background thread)
 
 if you are downloading something from the internet like movies, video, those are heavy processes that you want to put on background threads, you don't want to run those on the main thread but after you download all that data you need to go back onto the main thread (Thread 1) to update the UI.
 
 
 */
class BackgroundThreadViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    
    func fetchData() {
        
        DispatchQueue.global(qos: .background).async { //background thread (thread 10)
            
            //self basically creates a strong reference to this class(BackgroundThreadViewModel) so it knows downloadData() is actually in this class here
            let newData = self.downloadData()
            print("Check 1: \(Thread.isMainThread)")  //false (Not in Main Thread)
            print("Check 1: \(Thread.current)")  // Thread 4
            
            DispatchQueue.main.async { //main thread (thread 1)
                //if we want to return back and do something that updates the UI
                //put in main thread, dont put in background thread
                self.dataArray = newData
                print("Check 2: \(Thread.isMainThread)")  //true (In Main Thread)
                print("Check 2: \(Thread.current)")  // Thread 1
            }
            
        }
        
        
    }
    
    private func downloadData() -> [String] {
        var data: [String] = []
        
        for x in 0..<100 {
            data.append("\(x)")
            print(data)
        }
        return data
    }
}

struct BackgroundThreadBootcamp: View {
    
    @StateObject var vm = BackgroundThreadViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                Text("Load Data")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        vm.fetchData()
                    }
                
                ForEach(vm.dataArray, id: \.self) { item in
                        Text(item)
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct BackgroundThreadBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundThreadBootcamp()
    }
}
