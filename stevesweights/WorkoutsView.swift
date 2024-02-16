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
        NavigationView {
            VStack {
                NavigationLink(destination: ExercisesView()) {
                    Text("View Exercises")
                }
                .padding()
            }
            .navigationTitle("Workouts")
        }
    }
}
