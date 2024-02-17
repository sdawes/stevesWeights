//
//  AddExerciseToWorkoutView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 17/02/2024.
//

import Foundation
import SwiftUI
import CoreData

struct AddExercisesToWorkoutView: View {
    @Environment(\.managedObjectContext) var viewContext
    var workout: Workout
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.name, ascending: true)]
    ) var exercises: FetchedResults<Exercise>

    var body: some View {
        List {
            ForEach(exercises, id: \.self) { exercise in
                Button(action: {
                    addExerciseToWorkout(exercise)
                }) {
                    Text(exercise.name ?? "Unknown Exercise")
                }
            }
        }
        .navigationTitle("Add Exercises")
    }

    private func addExerciseToWorkout(_ exercise: Exercise) {
        // Assuming 'exercises' is a Set<Exercise> in your Workout entity
        workout.addToExercises(exercise)
        do {
            try viewContext.save()
        } catch {
            print("Error adding exercise to workout: \(error.localizedDescription)")
        }
    }
}

