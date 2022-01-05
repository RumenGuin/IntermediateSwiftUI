//
//  TypealiasBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 05/01/22.
//

import SwiftUI

struct MovieModel {
    let title: String
    let director: String
    let count: Int
}

typealias TVModel = MovieModel

struct TypealiasBootcamp: View {
    @State var item: MovieModel = MovieModel(title: "Title", director: "Joe", count: 5)
    @State var item2: TVModel = TVModel(title: "TV Title", director: "Emily", count: 15)
    var body: some View {
        VStack {
            Text(item.title)
            Text(item.director)
            Text("\(item.count)")
        }
    }
}

struct TypealiasBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TypealiasBootcamp()
    }
}
