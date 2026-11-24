//
//  EditWorkoutView.swift
//  WorkoutLog
//
//  Created by KCEMAC12 on 23/11/26.
//

import SwiftUI
import SwiftData

struct EditWorkoutView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let workout: Workout

    @State private var exerciseName: String
    @State private var muscleGroup: MuscleGroup
    @State private var sets: Int
    @State private var reps: Int
    @State private var weight: Double
    @State private var notes: String
    @State private var errorMessage = ""

    init(workout: Workout) {
        self.workout = workout

        _exerciseName = State(initialValue: workout.exerciseName)
        _muscleGroup = State(
            initialValue: MuscleGroup(rawValue: workout.muscleGroup) ?? .chest
        )
        _sets = State(initialValue: workout.sets)
        _reps = State(initialValue: workout.reps)
        _weight = State(initialValue: workout.weight)
        _notes = State(initialValue: workout.notes)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Exercise Details") {
                    TextField("Exercise Name", text: $exerciseName)

                    Picker("Muscle Group", selection: $muscleGroup) {
                        ForEach(MuscleGroup.allCases) { group in
                            Text(group.rawValue).tag(group)
                        }
                    }
                }

                Section("Workout Information") {
                    Stepper("Sets: \(sets)", value: $sets, in: 1...20)
                    Stepper("Reps: \(reps)", value: $reps, in: 1...100)

                    HStack {
                        Text("Weight (kg)")
                        Spacer()
                        TextField("Weight", value: $weight, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                }

                Section("Notes") {
                    TextField(
                        "Add notes (optional)",
                        text: $notes,
                        axis: .vertical
                    )
                    .lineLimit(3...5)
                }

                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }

                Section {
                    Button("Save Changes") {
                        updateWorkout()
                    }
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                }
            }
            .navigationTitle("Edit Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func updateWorkout() {
        let trimmedName = exerciseName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter an exercise name."
            return
        }

        guard sets > 0, reps > 0, weight >= 0 else {
            errorMessage = "Please enter valid workout details."
            return
        }

        workout.exerciseName = trimmedName
        workout.muscleGroup = muscleGroup.rawValue
        workout.sets = sets
        workout.reps = reps
        workout.weight = weight
        workout.notes = notes

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Unable to update workout. Please try again."
        }
    }
}

#Preview {
    EditWorkoutView(
        workout: Workout(
            exerciseName: "Bench Press",
            muscleGroup: "Chest",
            sets: 3,
            reps: 12,
            weight: 40
        )
    )
    .modelContainer(for: Workout.self, inMemory: true)
}

