//
//  ExerciseDetailView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import SwiftUI
import CoreData

struct ExerciseDetailView: View {
    @ObservedObject var exercise: Exercise
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var exerciseName: String = ""

    var body: some View {
        VStack {
            TextField("Exercise Name", text: $exerciseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("More details about the exercise...")
            Spacer()
        }
        .onAppear {
            exerciseName = exercise.name ?? ""
        }
        .navigationTitle(exercise.name ?? "Exercise Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveExercise()
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Delete") {
                    deleteExercise()
                }
            }
        }
    }

    private func saveExercise() {
        exercise.name = exerciseName
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving exercise: \(error.localizedDescription)")
        }
    }

    private func deleteExercise() {
        viewContext.delete(exercise)
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error deleting exercise: \(error.localizedDescription)")
        }
    }
}


