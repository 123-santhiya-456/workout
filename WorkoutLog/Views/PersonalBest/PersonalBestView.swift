//
//  PersonalBestView.swift
//  WorkoutLog
//
//  Created by KCEMAC12 on 24/11/26.
//


import SwiftUI
import SwiftData

struct PersonalBestView: View {

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            PersonalBestContentView(modelContext: modelContext)
                .navigationTitle("Personal Bests")
        }
    }
}

private struct PersonalBestContentView: View {

    @StateObject private var viewModel: DashboardViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(
            wrappedValue: DashboardViewModel(modelContext: modelContext)
        )
    }

    var body: some View {

        Group {
            if viewModel.personalBestWorkouts.isEmpty {

                ContentUnavailableView(
                    "No Personal Bests Yet",
                    systemImage: "trophy",
                    description: Text(
                        "Record workouts to track your highest weights."
                    )
                )

            } else {

                List {
                    ForEach(viewModel.personalBestWorkouts) { workout in

                        HStack(spacing: 15) {

                            Image(systemName: "trophy.fill")
                                .font(.title2)
                                .foregroundColor(.orange)

                            VStack(alignment: .leading, spacing: 6) {

                                Text(workout.exerciseName)
                                    .font(.headline)

                                Text(workout.muscleGroup)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text(workout.workoutDate, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {

                                Text(
                                    workout.weight.formatted(
                                        .number.precision(.fractionLength(1))
                                    ) + " kg"
                                )
                                .font(.headline)
                                .foregroundColor(.blue)

                                Text("Best Weight")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .onAppear {
            viewModel.calculateStatistics()
        }
    }
}

#Preview {
    PersonalBestView()
        .modelContainer(for: Workout.self, inMemory: true)
}
