//
//  WorkoutViewModel.swift
//  WorkoutLog
//
//  Created by KCEMAC12 on 19/11/26.
//


import Foundation
import SwiftData
import Combine

@MainActor
class WorkoutViewModel: ObservableObject {

    private let modelContext: ModelContext

    @Published var workouts: [Workout] = []
    @Published var errorMessage = ""

    // Initialize database connection
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchWorkouts()
    }

    // MARK: - Fetch Workouts

    func fetchWorkouts() {
        let descriptor = FetchDescriptor<Workout>(
            sortBy: [SortDescriptor(\.workoutDate, order: .reverse)]
        )

        do {
            workouts = try modelContext.fetch(descriptor)
        } catch {
            errorMessage = "Unable to load workouts."
            print("Fetch error: \(error.localizedDescription)")
        }
    }

    // MARK: - Add Workout

    func addWorkout(
        exerciseName: String,
        muscleGroup: String,
        sets: Int,
        reps: Int,
        weight: Double,
        notes: String
    ) -> Bool {

        guard !exerciseName.trimmingCharacters(in: .whitespaces).isEmpty,
              sets > 0,
              reps > 0,
              weight >= 0 else {
            errorMessage = "Please enter valid workout details."
            return false
        }

        let newWorkout = Workout(
            exerciseName: exerciseName,
            muscleGroup: muscleGroup,
            sets: sets,
            reps: reps,
            weight: weight,
            notes: notes
        )

        modelContext.insert(newWorkout)

        do {
            try modelContext.save()
            errorMessage = ""
            fetchWorkouts()
            return true
        } catch {
            modelContext.delete(newWorkout)
            errorMessage = "Unable to save workout."
            print("Save error: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Delete Workout

    func deleteWorkout(_ workout: Workout) {
        modelContext.delete(workout)

        do {
            try modelContext.save()
            fetchWorkouts()
        } catch {
            errorMessage = "Unable to delete workout."
            print("Delete error: \(error.localizedDescription)")
        }
    }
}
