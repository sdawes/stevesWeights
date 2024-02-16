//
//  ContentView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import SwiftUI

struct WorkoutsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("This is the Workouts view")
                    .padding()
            }
            .navigationTitle("Workouts")
        }
        
    }
}
