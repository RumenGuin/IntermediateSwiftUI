//
//  ArraysBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 04/01/22.
//

import SwiftUI

struct UserModel: Identifiable {
    let id = UUID().uuidString
    let name: String?
    let points: Int
    let isVerified: Bool
    
}

class ArrayModificationViewModel: ObservableObject {
    
    @Published var dataArray: [UserModel] = []
    @Published var filteredArray: [UserModel] = []
    @Published var mappedArray: [String] = []
    
    init() {
        getUsers()
        updateFilteredArray()
    }
    
    func updateFilteredArray() {
        
        
        //sort
      //  filteredArray = dataArray.sorted(by: {$0.points > $1.points}) //press curlybraces
        
        
        
        //filter
//        filteredArray = dataArray.filter({ user in
//            // user.points > 15
//             //!user.isVerified
//            //user.name.contains("i")
//        })
     //   filteredArray = dataArray.filter({!$0.isVerified})
        
        
        
        
        //map
//        mappedArray = dataArray.map({ user in
//            user.name ?? "No Name"
//        })
//        mappedArray = dataArray.map({$0.points.description})
        
        
        //if an user has no name(nil) the Compact Map will not include in the array.
        //i.e Compact Map will not include optional String(String?) that is nil.
//        mappedArray = dataArray.compactMap({ user in
//            user.name
//        })
//          mappedArray = dataArray.compactMap({$0.name})
        
        
        //putting is order of most points
        //making sure they are all verified
        //only displaying their name
        mappedArray = dataArray
                        .sorted(by: {$0.points > $1.points})
                        .filter({$0.isVerified})
                        .compactMap({$0.name})

        
    }
    
    func getUsers() {
        let user1 = UserModel(name: nil, points: 10, isVerified: false)
        let user2 = UserModel(name: "Tapas", points: 5, isVerified: true)
        let user3 = UserModel(name: "Arpan", points: 20, isVerified: true)
        let user4 = UserModel(name: "Rita", points: 13, isVerified: true)
        let user5 = UserModel(name: "Manotosh", points: 2, isVerified: true)
        let user6 = UserModel(name: "Rohit", points: 12, isVerified: false)
        let user7 = UserModel(name: nil, points: 16, isVerified: false)
        let user8 = UserModel(name: "Pritam", points: 23, isVerified: false)
        let user9 = UserModel(name: "Debjit", points: 15, isVerified: false)
        let user10 = UserModel(name: "Gaurav", points: 19, isVerified: false)
        self.dataArray.append(contentsOf: [
        user1,
        user2,
        user3,
        user4,
        user5,
        user6,
        user7,
        user8,
        user9,
        user10
        ])
    }
    
}

struct ArraysBootcamp: View {
    
    @StateObject var vm = ArrayModificationViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                
                ForEach(vm.mappedArray, id: \.self) { name in
                        Text(name)
                        .font(.title)
                }
                
                
                
                
//                ForEach(vm.filteredArray) { user in
//                    VStack(alignment: .leading) {
//                        Text(user.name)
//                            .font(.headline)
//                        HStack {
//                            Text("Points: \(user.points)")
//                            Spacer()
//                            if user.isVerified {
//                                Image(systemName: "checkmark.seal.fill")
//                            }
//                        }
//                    }
//                    .foregroundColor(.purple)
//                    .padding()
//                    .background(.gray.opacity(0.3))
//                    .cornerRadius(25)
//                    .padding(.horizontal, 20)
//                }
            }
           

        }
    }
}

struct ArraysBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ArraysBootcamp()
    }
}
