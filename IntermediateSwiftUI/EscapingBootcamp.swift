//
//  EscapingBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 05/01/22.
//

import SwiftUI

class EscapingViewModel: ObservableObject {
    
    @Published var text: String = "Hello"
    
    func getData() {
//        let newData = downloadData()
//        text = newData
//        downloadData3 { [weak self] returnedData in
//            //this self creates a strong reference to this class
//            self?.text = returnedData
//        }
        
        downloadData5 { [weak self] returnedResult in
            self?.text = returnedResult.data
        }
       
    }
    
    func downloadData() -> String {  //synchronous code (immediately execute and return)
        return "New Data"
    }
    //we dont want to give an external name thats why _(underscore)
    func downloadData2(completionHandler: (_ data: String) -> ()) { //Void == ()
        completionHandler("New Data2")
    }
    
    
    //@escaping makes our code asynchronous(means its NOT going to immediately execute and return)
    func downloadData3(completionHandler: @escaping (_ data: String) -> ()) { //Void == ()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler("New Data3")
        }
        
    }
    
    
    func downloadData4(completionHandler: @escaping (DownloadResult) -> ()) { //Void == ()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let result = DownloadResult(data: "New Data4")
            completionHandler(result)
        }
        
    }
    
    func downloadData5(completionHandler: @escaping DownloadCompletion) { //Void == ()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let result = DownloadResult(data: "New Data5")
            completionHandler(result)
        }
        
    }
    
}

struct DownloadResult {
    let data: String
    
}

typealias DownloadCompletion = (DownloadResult) -> ()

struct EscapingBootcamp: View {
    @StateObject var vm = EscapingViewModel()
    var body: some View {
        Text(vm.text)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.blue)
            .onTapGesture {
                vm.getData()
            }
        
    }
}

struct EscapingBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        EscapingBootcamp()
    }
}
