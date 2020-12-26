//
//  Joke.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 27/11/2020.
//

import Foundation
import CoreData

@objc(Joke)
class Joke: NSManagedObject, Managed, JokeProtocol {
    @NSManaged var id: Int
    @NSManaged var setup: String
    @NSManaged var punchline: String
    
    @NSManaged var created: Date
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        created = Date()
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(Joke.created), ascending: false)]
    }
    
    static func byIdFetchRequest(id: Int) -> NSFetchRequest<Joke> {
        let sorted = sortedFetchRequest
        sorted.fetchLimit = 1
        sorted.predicate = NSPredicate(format: "%K == %d", #keyPath(Joke.id), id)
        return sorted
    }
    
    func configure(with jokeDto: JokeDTO) {
        id = jokeDto.id
        setup = jokeDto.setup
        punchline = jokeDto.punchline
    }
}
