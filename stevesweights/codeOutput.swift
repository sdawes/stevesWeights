//
//  stevesweightsApp.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import SwiftUI

@main
struct stevesweightsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
//
//  MainView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import Foundation
import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Group {
                WorkoutsView()
                    .tabItem {
                        Label("Workouts", systemImage: "list.dash")
                    }
                
                ExerciseListView()
                    .tabItem {
                        Label("Exercises", systemImage: "flame")
                    }
            }
        }
    }
}




//
//  ContentView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import SwiftUI

struct WorkoutsView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)],
        animation: .default)
    private var workouts: FetchedResults<Workout>
    @State private var showingAddWorkoutView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(workouts, id: \.self) { workout in
                    VStack(alignment: .leading) {
                        Text("Workout: \(workout.date!, formatter: itemFormatter)")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addWorkout) {
                        Label("Add Workout", systemImage: "plus")
                    }
                }
            }
            
        }
    }
    
    private func addWorkout() {
        let newWorkout = Workout(context: viewContext)
        newWorkout.id = UUID()
        newWorkout.date = Date()
        
        do {
            try viewContext.save()
        } catch {
            // Handle the save error here
            print("Error saving workout: \(error)")
        }
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

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
        NavigationStack {
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
            }
        }
    }
}







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
    @Environment(\.dismiss) var dismiss
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
                dismiss()
            } catch {
                // Handle the error appropriately
                print("Error saving exercise: \(error.localizedDescription)")
            }
        }
}


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

//
//  Persistence.swift
//  stevesweights
//
//  Created by Stephen Dawes on 16/02/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "stevesweights")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // Real error handling should be here, possibly involving user feedback and error resolution steps.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}

