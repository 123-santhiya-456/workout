//
//  DashboardViewModel.swift
//  WorkoutLog
//
//  Created by KCEMAC12 on 19/11/26.
//

import Foundation
import SwiftData
import Combine

@MainActor
class DashboardViewModel: ObservableObject {

    @Published var totalWorkouts = 0
    @Published var workoutsThisWeek = 0
    @Published var totalSets = 0
    @Published var personalBests = 0
    @Published var recentWorkouts: [Workout] = []
    @Published var personalBestWorkouts: [Workout] = []
    
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        calculateStatistics()
    }

    func calculateStatistics() {

        let descriptor = FetchDescriptor<Workout>()

        do {
            let workouts = try modelContext.fetch(descriptor)
            recentWorkouts = Array(workouts.prefix(3))
            
            totalWorkouts = workouts.count

            let calendar = Calendar.current
            let startOfWeek = calendar.dateInterval(
                of: .weekOfYear,
                for: Date()
            )?.start ?? Date()

            workoutsThisWeek = workouts.filter {
                $0.workoutDate >= startOfWeek
            }.count

            totalSets = workouts.reduce(0) {
                $0 + $1.sets
            }

            // Calculate the highest weight for each exercise
            let groupedWorkouts = Dictionary(
                grouping: workouts,
                by: { $0.exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            )

            personalBestWorkouts = groupedWorkouts.values.compactMap { exerciseWorkouts in
                exerciseWorkouts.max(by: { $0.weight < $1.weight })
            }

            personalBests = personalBestWorkouts.count

        } catch {
            print("Dashboard statistics error: \(error.localizedDescription)")
        }
    }
}

