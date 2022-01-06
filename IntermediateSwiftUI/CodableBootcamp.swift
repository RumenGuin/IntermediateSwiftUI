//
//  CodableBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 05/01/22.
//

import SwiftUI
/*
 JSON (JavaScript Object Notation)
 Codable = Decodable + Encodable
 Decode data from JSON data on the internet to data that we can use in our app.
 Take the data in our app and we can encoded to send it back on the internet as JSON data.
 */

struct CustomerModel: Identifiable, Codable { // Codable = Decodable + Encodable
    let id: String //we want to get random id from the internet
    let name: String
    let points: Int
    let isPremium: Bool
    
    ///Codable Protocol do this all behind the scene for us. We DO NOT need to do this
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case points
//        case isPremium
//    }
//
//    init(id: String, name: String, points: Int, isPremium: Bool) {
//        self.id = id
//        self.name = name
//        self.points = points
//        self.isPremium = isPremium
//    }
//    //init that will decode for us
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.points = try container.decode(Int.self, forKey: .points)
//        self.isPremium = try container.decode(Bool.self, forKey: .isPremium)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(points, forKey: .points)
//        try container.encode(isPremium, forKey: .isPremium)
//    }
}


class CodableViewModel: ObservableObject {
    
    @Published var customer: CustomerModel? = nil
    
    init() {
        getData()
    }
    
    
    func getData() {
        //as getJSONData return Data? (optional Data) we will use guard let
        guard let data = getJSONData() else {return}
        self.customer = try? JSONDecoder().decode(CustomerModel.self, from: data)
        
//        do {
//        self.customer = try JSONDecoder().decode(CustomerModel.self, from: data)
//        } catch let error {
//            print("Error Decoding \(error)")
//        }
        
        
        
        
        //manually decode
//        if
//            let localData = try? JSONSerialization.jsonObject(with: data, options: []),
//            //as? -> we try to convert into(optional typecast)
//            let dictionary = localData as? [String: Any],
//            let id = dictionary["id"] as? String,
//            let name = dictionary["name"] as? String,
//            let points = dictionary["points"] as? Int,
//            let isPremium = dictionary["isPremium"] as? Bool {
//
//            let newCustomer = CustomerModel(id: id, name: name, points: points, isPremium: isPremium)
//            customer = newCustomer
//        }
    }
    
    
    func getJSONData() -> Data? { //Data is optional because it might not get data from internet
        
        let customer = CustomerModel(id: "09876", name: "Arpan", points: 100, isPremium: true)
        let jsonData = try? JSONEncoder().encode(customer)
        
//        let dictionary: [String:Any] = [
//            "id" : "12345",
//            "name" : "Rumen",
//            "points" : 5,
//            "isPremium" : false
//
//        ]
//
//      //  try -> going to try to do this but its ok if its fail
//      // ? -> let jsonData is optional thats why -> try?
//        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        return jsonData
    }
}

struct CodableBootcamp: View {
    @StateObject var vm = CodableViewModel()
    var body: some View {
        VStack(spacing: 20) {
            if let customer = vm.customer {
                Text(customer.name)
                Text("\(customer.points)")
                Text(customer.isPremium.description)
                Text(customer.id)
            }
        }
    }
}

struct CodableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CodableBootcamp()
    }
}
