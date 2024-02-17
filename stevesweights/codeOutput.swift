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
                WorkoutsListView()
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

struct WorkoutsListView: View {
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
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        VStack(alignment: .leading) {
                            Text("Workout: \(workout.date!, formatter: itemFormatter)")
                                .font(.headline)
                        }
                    }
                    
                }
                .onDelete(perform: deleteWorkouts)
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
    
    private func deleteWorkouts(offsets: IndexSet) {
        withAnimation {
            offsets.map { workouts[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Handle the Core Data error
                print("Error deleting workout: \(error)")
            }
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
//  WorkoutDetailView.swift
//  stevesweights
//
//  Created by Stephen Dawes on 17/02/2024.
//

import SwiftUI
import CoreData

struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.managedObjectContext) private var viewContext // Inject managedObjectContext
    @Environment(\.dismiss) private var dismiss // For dismissing the view

    var body: some View {
        VStack {
            Text("Workout Details")
                .font(.title)
            
            Text("Workout Date: \(workout.date!, formatter: itemFormatter)")
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Workout Detail")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Delete") {
                    deleteWorkout() // Correct the function name here
                }
            }
        }
    }
    
    private func deleteWorkout() {
        viewContext.delete(workout)
        do {
            try viewContext.save()
            dismiss() // Correctly dismiss the view
        } catch {
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
                .onDelete(perform: deleteExercises)
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Exercise") {
                        isAddingExercise = true
                    }
                }
            }
            .sheet(isPresented: $isAddingExercise) {
                AddExerciseView()
            }
        }
    }

    private func deleteExercises(offsets: IndexSet) {
        withAnimation {
            offsets.map { exercises[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
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

