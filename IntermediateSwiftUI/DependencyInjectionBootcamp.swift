//
//  DependencyInjectionBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 24/01/22.
//

import SwiftUI
import Combine
/*
 dependency injection(DI) is basically the alternative to using the singleton design pattern
 Problems with singlton :-
    1. Singletons are Global (can be access from anywhere) (avoid global variables while building production apps)
    2. cannot customize the init
    3. cannot swap out dependenscies(we can't use another dataService class)
    
 */
struct PostsModel:Identifiable, Codable {
    //api data
    /*
     {
         "userId": 1,
         "id": 1,
         "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
         "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
       }
     */
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

protocol DataServiceProtocol {
    func getData() -> AnyPublisher<[PostsModel], Error>
}


class ProductionDataService: DataServiceProtocol {
    
    //static let instance = ProductionDataService() //singleton (single instance)
    
    let url: URL
    init(url: URL) {
        self.url = url
    }
    
    func getData() -> AnyPublisher<[PostsModel], Error>{
        URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [PostsModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}

class MockDataService: DataServiceProtocol {
    let testData: [PostsModel]
    init(data: [PostsModel]?) {
        self.testData = data ?? [
            PostsModel(userId: 1, id: 1, title: "One", body: "one"),
            PostsModel(userId: 2, id: 2, title: "Two", body: "two")
            ]
    }
    func getData() -> AnyPublisher<[PostsModel], Error>{
        //publisher that emit an output to each subscriber just once and finishes -> Just
        Just(testData)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }
}


class DependencyInjectionViewModel: ObservableObject {
    
    @Published var dataArray: [PostsModel] = []
    var cancellables = Set<AnyCancellable>()
    let dataService: DataServiceProtocol
    //DI injecting your dependencies into your class/struct.
    //here we're taking the dataService which is our dependency and we're going to inject it through the init into this view model(DIVM) so that this viewmodel has access to the dataService
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadPosts()
    }
    
    private func loadPosts() {
        //ProductionDataService.instance.getData()
        dataService.getData()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedPosts in
                self?.dataArray = returnedPosts
            }
            .store(in: &cancellables)

    }
}

struct DependencyInjectionBootcamp: View {
    @StateObject private var vm: DependencyInjectionViewModel
    init(dataService: DataServiceProtocol) {
        _vm = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray) {post in
                    Text(post.title)
                }
            }
        }
    }
}

struct DependencyInjectionBootcamp_Previews: PreviewProvider {
    
   // static let dataService = ProductionDataService(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
    static let dataService = MockDataService(data: [
    PostsModel(userId: 122, id: 123, title: "HueHue", body: "Rumennn")
    ])
    static var previews: some View {
        DependencyInjectionBootcamp(dataService: dataService)
    }
}
