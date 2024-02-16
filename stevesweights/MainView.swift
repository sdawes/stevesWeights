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
