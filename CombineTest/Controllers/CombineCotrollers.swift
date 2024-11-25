//
//  CombineCotrollers.swift
//  CombineTest
//
//  Created by Mourad KIRAT on 17/02/2024.
//

import Foundation
import Combine

// Model representing data from the API
struct Post: Codable {
    let id: Int
    let title: String
    let body: String
}

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPosts() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .catch { error in
                Just([])
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedPosts in
                self?.posts = fetchedPosts
            }
            .store(in: &cancellables)
    }
    // FOR ADD
    func addDataToAPI(title: String, body: String) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newPost = Post(id: posts.count + 1, title: title, body: body)
        
        let encoder = JSONEncoder()
        guard let postData = try? encoder.encode(newPost) else { return }
        request.httpBody = postData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: Post.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // Do nothing on successful completion
                case .failure(let error):
                    print("Error creating post: \(error)")
                    // Handle error here
                }
            }, receiveValue: { [weak self] createdPost in
                // Update the ViewModel with the newly created post
                self?.posts.append(createdPost)
            })
            .store(in: &cancellables)
    }
}

