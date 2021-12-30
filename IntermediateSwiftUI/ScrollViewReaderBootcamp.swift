//
//  ScrollViewReaderBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 30/12/21.
//

import SwiftUI
//eg. used in WhatsApp
struct ScrollViewReaderBootcamp: View {
    @State var scrollToIndex: Int = 0
    @State var textFieldText: String = ""
    var body: some View {
        VStack {
            TextField("  Enter Number", text: $textFieldText)
                .frame(height: 55)
                .border(.gray)
                .padding(.horizontal)
                .keyboardType(.numberPad)
            
            Button("Scroll Now") {
                withAnimation(.spring()) {
                    if let index = Int(textFieldText) {
                        scrollToIndex = index
                    }
                    
                   // proxy.scrollTo(49, anchor: .top)
                }
            }
            
            ScrollView {
                ScrollViewReader {proxy in
                    
                  
                    ForEach(0..<50) {index in
                        Text("This is item \(index)")
                            .font(.headline)
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding()
                            .id(index)
                    }
                    .onChange(of: scrollToIndex) { newValue in
                        withAnimation(.spring()) {
                            proxy.scrollTo(newValue, anchor: nil)
                        }
                    }
                }
                
            }
        }
    }
}

struct ScrollViewReaderBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReaderBootcamp()
    }
}
