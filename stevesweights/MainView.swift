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




