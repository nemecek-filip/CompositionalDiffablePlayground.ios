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
    
    func get<T: Decodable>(fromUrl url: URL, completion: @escaping (T?) -> ()) {
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
            
            let decoder = JSONDecoder()
            
            completion(try? decoder.decode(T.self, from: data))
            
        }.resume()
    }
    
    func getJokes(completion: @escaping ([JokeDTO]?) -> ()) {
        self.get(fromUrl: URL(string: "https://official-joke-api.appspot.com/jokes/ten")!, completion: completion)
    }
}
