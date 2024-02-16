//
//  AddExerciseView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import Foundation
import SwiftUI

struct AddExerciseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var exerciseName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Exercise name", text: $exerciseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save Exercise") {
                addExercise()
            }
            .disabled(exerciseName.isEmpty)
        }
        .navigationTitle("Add Exercise")
    }

    private func addExercise() {
        let newExercise = Exercise(context: viewContext)
        newExercise.name = exerciseName

        do {
            try viewContext.save()
            // Add logic to dismiss the view if needed
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

