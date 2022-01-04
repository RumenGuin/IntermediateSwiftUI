//
//  HashableBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 04/01/22.
//

import SwiftUI
//if it conforms to Identifiable we have to put an id
//we dont need id to conform to Hashable
struct MyCustomModel: Hashable {
    //let id = UUID().uuidString
    let title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
}


struct HashableBootcamp: View {
    let data: [MyCustomModel] = [
        MyCustomModel(title: "One"),
        MyCustomModel(title: "two"),
        MyCustomModel(title: "three"),
        MyCustomModel(title: "four"),
        MyCustomModel(title: "five")
    ]
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                
//                ForEach(data) {item in
//                    //Text(item.id)
//                    Text(item.title)
//                }
                
                ForEach(data, id: \.self) {item in
                    Text(item.hashValue.description)
                    Text(item.title)
                        .font(.headline)
                }
            }
        }
    }
}

struct HashableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        HashableBootcamp()
    }
}
