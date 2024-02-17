//
//  WorkoutDetailView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 17/02/2024.
//

import SwiftUI
import CoreData

struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddExercisesView = false

    var body: some View {
        VStack {
            Text("Workout Details")
                .font(.title)
            
            Text("Workout Date: \(workout.date!, formatter: itemFormatter)")
                .padding()
            
            Button("Add Exercise to Workout") {
                showingAddExercisesView = true
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Workout Detail")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Delete") {
                    deleteWorkout()
                }
            }
        }
        .sheet(isPresented: $showingAddExercisesView) {
                    AddExercisesToWorkoutView(workout: workout).environment(\.managedObjectContext, viewContext)
                }
    }

    private func deleteWorkout() {
        viewContext.delete(workout)
        do {
            try viewContext.save()
            dismiss()
        } catch {
            // Handle the deletion error
            print("Error deleting workout: \(error.localizedDescription)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()



