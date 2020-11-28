//
//  Database.swift
//  CompositionalDiffablePlayground
//
//  Created by Filip Němeček on 27/11/2020.
//

import Foundation
import CoreData


// https://nemecek.be/blog/41/my-approach-to-setting-up-core-data-stack
class Database {
    static let shared = Database()
    private var persistentContainer: NSPersistentContainer!
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundContextDidSave(notification:)), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc func backgroundContextDidSave(notification: Notification) {
        guard let notificationContext = notification.object as? NSManagedObjectContext else { return }
        
        guard notificationContext !== context else {
            return
        }
        
        context.perform {
            self.context.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    func performBackgroundTask(block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
    func prepare() {
        persistentContainer = NSPersistentContainer(name: "Database")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
                fatalError()
            }
        }
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext() {
        do {
            if persistentContainer.viewContext.hasChanges {
                try persistentContainer.viewContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
