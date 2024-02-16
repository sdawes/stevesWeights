//
//  ExerciseListView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import SwiftUI
import CoreData

struct ExerciseListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.name, ascending: true)],
        animation: .default)
    private var exercises: FetchedResults<Exercise>
    @State private var isAddingExercise = false
    
    var body: some View {
        NavigationStack { // Updated to use NavigationStack
            List {
                ForEach(exercises, id: \.self) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        Text(exercise.name ?? "Unnamed Exercise")
                    }
                }
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Exercise") {
                        isAddingExercise = true
                    }
                }
            }
            .navigationDestination(isPresented: $isAddingExercise) {
                AddExerciseView()
            }        }
    }
}







