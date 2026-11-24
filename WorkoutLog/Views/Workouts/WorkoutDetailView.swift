//
//  WorkoutDetailView.swift
//  WorkoutLog
//
//  Created by KCEMAC12 on 23/11/26.
//


import SwiftUI
import SwiftData

struct WorkoutDetailView: View {

    
    let workout: Workout
    @State private var showingEditWorkout = false
    
    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: 25) {

                // Exercise Header
                VStack(alignment: .leading, spacing: 10) {

                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 45))
                        .foregroundColor(.blue)

                    Text(workout.exerciseName)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(workout.muscleGroup)
                        .font(.headline)
                        .foregroundColor(.blue)

                    Label(
                        workout.workoutDate.formatted(
                            date: .long,
                            time: .shortened
                        ),
                        systemImage: "calendar"
                    )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }

                // Workout Statistics
                VStack(alignment: .leading, spacing: 15) {

                    Text("Workout Information")
                        .font(.title2)
                        .fontWeight(.bold)

                    DetailRow(
                        title: "Sets",
                        value: "\(workout.sets)"
                    )

                    DetailRow(
                        title: "Repetitions",
                        value: "\(workout.reps)"
                    )

                    DetailRow(
                        title: "Weight",
                        value: "\(workout.weight.formatted(.number.precision(.fractionLength(1)))) kg"
                    )

                    DetailRow(
                        title: "Total Repetitions",
                        value: "\(workout.sets * workout.reps)"
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)

                // Notes
                VStack(alignment: .leading, spacing: 10) {

                    Text("Notes")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(
                        workout.notes.isEmpty
                        ? "No notes added."
                        : workout.notes
                    )
                    .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
        }
        .navigationTitle("Workout Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    showingEditWorkout = true
                }
            }
        }
        .sheet(isPresented: $showingEditWorkout) {
            EditWorkoutView(workout: workout)
        }
    }
}

// Reusable detail row
struct DetailRow: View {

    let title: String
    let value: String

    var body: some View {

        HStack {
            Text(title)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutDetailView(
            workout: Workout(
                exerciseName: "Bench Press",
                muscleGroup: "Chest",
                sets: 3,
                reps: 12,
                weight: 40,
                notes: "Example workout"
            )
        )
    }
    .modelContainer(for: Workout.self, inMemory: true)
}
