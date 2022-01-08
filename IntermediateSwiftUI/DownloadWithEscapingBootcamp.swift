//
//  DownloadWithEscapingBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 07/01/22.
//

import SwiftUI
//id == Identifiable
//decode and encode this PostModel from JSON == Codable
struct PostModel: Identifiable, Codable {
    // used same properties with case sensitive as in API
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class DownloadWithEscapingViewModel: ObservableObject {
    
    @Published var posts: [PostModel] = []
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        //when we create an URL it is optional so we use guard let to unwrap it
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        downloadData(fromURL: url) { data in
            if let data = data {
                
                guard let newPosts = try? JSONDecoder().decode([PostModel].self, from: data)
                else { return }
                DispatchQueue.main.async { [weak self] in //we are updating the UI hence main Thread 1
                    self?.posts = newPosts
                }
                
            }else {
                print("No Data")
            }
        }
    }
    
    //fromURL: external name
    func downloadData(fromURL url: URL, completionHandler: @escaping(_ data: Data?) -> ()){
        
        URLSession.shared.dataTask(with: url) { data, response, error in //dataTask automatically goes onto a background thread
            
            //check data, no error, its a https url response
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    print("Error downloading Data")
                    completionHandler(nil) //if error data == nil
                    return
                }
            
            completionHandler(data) //if no error data == data
            
        }.resume() // to start above closure(like start function)

    }
}

struct DownloadWithEscapingBootcamp: View {
    @StateObject var vm = DownloadWithEscapingViewModel()
    var body: some View {
        List {
            ForEach(vm.posts) { post in
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

struct DownloadWithEscapingBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DownloadWithEscapingBootcamp()
    }
}
