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
    @Environment(\.presentationMode) var presentationMode
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
            dismiss() // Dismiss the view programmatically after saving
        } catch {
            // Handle the error appropriately
            print("Error saving exercise: \(error.localizedDescription)")
        }
    }
}


