//
//  stevesweightsApp.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import SwiftUI

@main
struct stevesweightsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
