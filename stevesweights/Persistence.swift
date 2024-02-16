//
//  Persistence.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "stevesweights")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // Real error handling should be here, possibly involving user feedback and error resolution steps.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

