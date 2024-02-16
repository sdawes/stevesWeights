//
//  ExerciseDetailView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import Foundation
import SwiftUI

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
        }
    }
    
    private func saveExercise() {
        exercise.name = exerciseName
        do {
            try viewContext.save()
            dismiss() // Dismiss the view programmatically after saving
        } catch {
            // Handle the save error appropriately
            print("Error saving exercise: \(error.localizedDescription)")
        }
    }
}

