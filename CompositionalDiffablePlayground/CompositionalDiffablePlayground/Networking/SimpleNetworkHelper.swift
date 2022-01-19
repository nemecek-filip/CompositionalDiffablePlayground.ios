//
//  SimpleNetworkHelper.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 28/11/2020.
//

import Foundation

// This is NOT an example of proper networking. I just needed something quick to grab data
class SimpleNetworkHelper {
    static let shared = SimpleNetworkHelper()
    
    func get<T: Decodable>(fromUrl url: URL, customDecoder: JSONDecoder? = nil, completion: @escaping (T?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                assertionFailure("No error but also no data?!")
                completion(nil)
                return
            }
            
            let decoder = customDecoder ?? JSONDecoder()
            
            do {
                let decoded = try decoder.decode(T.self, from: data)
                completion(decoded)
            } catch {
                completion(nil)
                print(error)
            }
            
        }.resume()
    }
    
    func getJokes(completion: @escaping ([JokeDTO]?) -> ()) {
        self.get(fromUrl: URL(string: "https://official-joke-api.appspot.com/jokes/ten")!, completion: completion)
    }
    
    func getArticles(completion: @escaping ([ArticleDTO]?) -> ()) {
        self.get(fromUrl: URL(string: "https://iosfeeds.com/api/articles/")!, completion: completion)
    }
    
    func getAppNews(completion: @escaping (AppNewsResultsDTO?) -> ()) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self.get(fromUrl: URL(string: "https://indiecatalog.app/api/news/")!, customDecoder: decoder, completion: completion)
    }
}
