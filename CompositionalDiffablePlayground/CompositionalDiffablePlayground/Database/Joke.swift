//
//  Joke.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 27/11/2020.
//

import Foundation
import CoreData

class Joke: NSManagedObject, Managed {
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
}
