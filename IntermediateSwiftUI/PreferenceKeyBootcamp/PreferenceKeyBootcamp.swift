//
//  PreferenceKeyBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 27/01/22.
//

import SwiftUI
/*
 eg. of preference key
 When we are setting the title in a navigation view (.navigationTitle) we are actually updating the parent title from a child view, (In swiftUI, data flows from parent views down to child views and the only we can get it flow back is if we use a binding) but when we're setting the title on a navigation view there is no binding we just set the title as a string and it updates the parent view and that's because behind the scenes it is using a preference key.
 */

struct PreferenceKeyBootcamp: View {
    @State private var text: String = "Hello, World!"
    var body: some View {
        NavigationView {
            VStack {
                SecondaryScreen(text: text)
                    .navigationTitle("Navigation Title")
            }
            
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
            self.text = value
        }
    }
}

struct PreferenceKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceKeyBootcamp()
    }
}

extension View {
    func customTitle(_ text: String) -> some View {
       preference(key: CustomTitlePreferenceKey.self, value: text)
    }
}

struct SecondaryScreen: View {
    let text: String
    @State private var newValue: String = ""
    var body: some View {
        Text(text)
            .onAppear {
                getDataFromDatabase()
            }
            .customTitle(newValue)
    }
    
    func getDataFromDatabase() {
        //download
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.newValue = "New Value from Database"
        }
    }
}


struct CustomTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}
