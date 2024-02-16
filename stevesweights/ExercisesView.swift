//
//  ExercisesView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import Foundation
import SwiftUI
import CoreData

struct ExercisesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.name, ascending: true)],
        animation: .default)
    private var exercises: FetchedResults<Exercise>

    var body: some View {
        List {
            ForEach(exercises, id: \.self) { exercise in
                Text(exercise.name ?? "Unnamed Exercise")
            }
        }
        .navigationTitle("Exercises")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddExerciseView()) {
                    Label("Add Exercise", systemImage: "plus")
                }
            }
        }
    }
}
