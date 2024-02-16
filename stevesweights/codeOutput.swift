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
            WorkoutsView()
                .tabItem {
                    Label("Workouts", systemImage: "list.dash")
                }
            
            ExerciseListView() // Updated to use ExerciseListView
                .tabItem {
                    Label("Exercises", systemImage: "flame")
                }
            // Placeholder tabs
            Text("Placeholder 1")
                .tabItem {
                    Label("Placeholder 1", systemImage: "square.fill")
                }
            
            Text("Placeholder 2")
                .tabItem {
                    Label("Placeholder 2", systemImage: "circle.fill")
                }
            
            Text("Placeholder 3")
                .tabItem {
                    Label("Placeholder 3", systemImage: "triangle.fill")
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
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            VStack {
                Text("This is the Workouts view")
                    .padding()
            }
        }
        .navigationTitle("Workouts")
    }
}
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

    var body: some View {
        NavigationView {
            List {
                ForEach(exercises, id: \.self) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        Text(exercise.name ?? "Unnamed Exercise")
                    }
                }
            }
            .navigationTitle("Exercises")
            .onAppear {
                print("ExerciseListView appeared") // Add this line
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddExerciseView()) {
                        Label("Add Exercise", systemImage: "plus")
                    }
                }
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
    @State private var exerciseName: String = ""

    var body: some View {
        VStack {
            TextField("Exercise Name", text: $exerciseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Example static text, replace with dynamic content as needed
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
                    exercise.name = exerciseName
                    try? viewContext.save()
                }
            }
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

