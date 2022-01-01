//
//  ViewBuilderBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 01/01/22.
//

import SwiftUI

//all the components we are building/using in swiftui are ViewBuilders

struct HeaderViewGeneric<Content: View>: View {
    let title: String
    let content: Content
    /// self.property = parameter
    /// We are initialising property so that's why self.property
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()  //content() is a function now
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)

            content
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
    }
}

struct CustomHStack<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
        }
    }
}

struct ViewBuilderBootcamp: View {
    var body: some View {
        VStack {
            
            HeaderViewGeneric(title: "Header Generic") {
                //This is the content part
                VStack {
                    Text("Rumen")
                    HStack {
                        Text("Guin")
                        Image(systemName: "bolt.fill")
                    }
                }
                
            }
            // CustomHStack == HStack
            CustomHStack {
                Text("HI")
                Text("HI")
            }
            
            HStack {
                Text("HI")
                Text("HI")
            }
            
        }
        
        
    }
}

struct ViewBuilderBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        //ViewBuilderBootcamp()
        LocalViewBuilder(type: .two)
    }
}

struct LocalViewBuilder: View {
    enum ViewType {
        case one, two, three
    }
    let type: ViewType
    
    var body: some View {
        VStack {
            headerSection
        }
    }
    
    @ViewBuilder private var headerSection: some View {
        
        switch type {
        case .one:
            viewOne
        case .two:
            viewTwo
        case .three:
            viewThree
        }
       
//            if type == .one { viewOne
//                            }
//
//            if type == .two {
//               viewTwo
//            }
//
//            if type == .three {
//                viewThree
//            }
        
    }
    
    private var viewOne: some View {
        Text("One")

    }
    
    private var viewTwo: some View {
        VStack {
            Text("Two")
            Image(systemName: "bolt.fill")
        }
    }
    
    private var viewThree: some View {
        Image(systemName: "heart.fill")
    }
}
