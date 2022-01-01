//
//  GenericsBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 01/01/22.
//

import SwiftUI

struct StringModel {
    let info: String?
    
    func removeInfo() -> StringModel {
        return StringModel(info: nil)
    }
}

struct BoolModel {
    let info: Bool?
    
    func removeInfo() -> BoolModel {
        return BoolModel(info: nil)
    }
}
//any type == Generic
//T == CustomType/Any Type
struct GenericModel<T> {
    let info: T?
    func removeInfo() -> GenericModel {
        GenericModel(info: nil)
    }
}

class GenericsViewModel: ObservableObject {
    @Published var stringModel = StringModel(info: "Hello World")
    @Published var boolModel = BoolModel(info: true)
    
    @Published var genericStringModel = GenericModel(info: "Helloe Rumen")
    @Published var genericBoolModel = GenericModel(info: true)
    
    func removeData() {
        stringModel = stringModel.removeInfo()
        boolModel = boolModel.removeInfo()
        genericStringModel = genericStringModel.removeInfo()
        genericBoolModel = genericBoolModel.removeInfo()
    }
}

struct GenericView<T: View>: View {
    let content: T  //custom type conform to View only
    let title: String
    var body: some View {
        VStack {
            Text(title)
            content
        }
    }
}

struct GenericsBootcamp: View {
    @StateObject private var vm = GenericsViewModel()
    
    var body: some View {
        VStack (spacing: 20){
            //content == anything that conforms to View(Shapes, Text, Image, New Screen)
            GenericView(content: RoundedRectangle(cornerRadius: 25), title: "New View!")
           // GenericView(title: "New View")
            Text(vm.stringModel.info ?? "No data")
            Text(vm.boolModel.info?.description ?? "No Data")
            
            Text(vm.genericStringModel.info ?? "No Value")
            Text(vm.genericBoolModel.info?.description ?? "Noo")
                
        }
        .frame(width: 250, height: 250)
        .onTapGesture {
            vm.removeData()
        }
    }
}

struct GenericsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GenericsBootcamp()
    }
}
