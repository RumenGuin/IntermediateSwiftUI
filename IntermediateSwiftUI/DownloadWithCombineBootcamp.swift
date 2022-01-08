//
//  DownloadWithCombineBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 08/01/22.
//
//Combine -> ios 13+
import Combine
import SwiftUI

//id == Identifiable
//decode and encode this PostModel from JSON == Codable
struct PostModel2: Identifiable, Codable {
    // used same properties with case sensitive as in API
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class DownloadWithCombineViewModel: ObservableObject {
    @Published var posts: [PostModel2] = []
    var cancellables = Set<AnyCancellable>() //if we want to cancel in future we can access this var and call cancel
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        
        /* Combine Discussion
         
         1. sign up for monthly subscription for package to be delivered
         2. the comapny would make the package behind the scene
         3. receive the package at your front door
         4. make sure the box isn't damaged
         5. open and make sure the item is correct
         6. use the item!!
         7. cancellable at any time...
        
         
         1. create the publisher
         2. subscribe publisher on background thread (dataTaskPublisher implicitly goes into background thread)
         3. receive on main thread
         4. tryMap (check that the data is good) tryMap is a Map that can fail and throw an error
         5. decode (decode data into PostModel2)
         6. sink (put the item into our app)
         7. store (cancel subscription if needed)
         */
         
        
        URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .background))  //(as it is in background thread implicitly)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [PostModel2].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .sink(receiveValue: { [weak self] returnedPosts in
                self?.posts = returnedPosts
            })
//            .sink { completion in
//
//                switch completion {
//                case .finished:
//                    print("finished")
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//
//                //print("Completion: \(completion)")
//            } receiveValue: { [weak self] returnedPosts in
//                self?.posts = returnedPosts
//            }

            .store(in: &cancellables)
        
    }
    
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                  throw URLError(.badServerResponse)
        }
        return output.data
    }
}

struct DownloadWithCombineBootcamp: View {
    @StateObject var vm = DownloadWithCombineViewModel()
    var body: some View {
        List {
            ForEach(vm.posts) {post in
                
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.title)
                    Text(post.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct DownloadWithCombineBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithCombineBootcamp()
    }
}
