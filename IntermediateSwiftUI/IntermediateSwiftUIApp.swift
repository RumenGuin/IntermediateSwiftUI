//
//  IntermediateSwiftUIApp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 15/12/21.
//

import SwiftUI

@main
struct IntermediateSwiftUIApp: App {
    
    let currentUserisSignedIn: Bool
    
    init() {
        //arguments passed on launch
        //both do same work
        //let userIsSignedIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true : false
        let userIsSignedIn: Bool = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn") ? true : false
        
        
        //environment variables
        //let value = ProcessInfo.processInfo.environment["-UITest_startSignedIn2"]
        //let userIsSignedIn: Bool = value == "true" ? true : false
        
        
        self.currentUserisSignedIn = userIsSignedIn
        //print("User is signedIn \(userIsSignedIn)")
    }
    var body: some Scene {
        WindowGroup {
            //UITestingBootcampView(currentUserIsSignedIn: currentUserisSignedIn)
            UIViewControllerRepresentableBootcamp()
        }
    }
}
