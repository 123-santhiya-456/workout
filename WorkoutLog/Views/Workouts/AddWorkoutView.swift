//
//  AddWorkoutView.swift
//  WorkoutLog
//
//  Created by KCEMAC12 on 23/11/26.
//


import SwiftUI
import SwiftData

struct AddWorkoutView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var exerciseName = ""
    @State private var muscleGroup = MuscleGroup.chest
    @State private var sets = 3
    @State private var reps = 12
    @State private var weight = 0.0
    @State private var notes = ""

    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {

                Section("Exercise Details") {

                    TextField("Exercise Name", text: $exerciseName)

                    Picker("Muscle Group", selection: $muscleGroup) {
                        ForEach(MuscleGroup.allCases) { group in
                            Text(group.rawValue)
                                .tag(group)
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
                    TextField("Add notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }

                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }

                Section {
                    Button("Save Workout") {
                        saveWorkout()
                    }
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                }
            }
            .navigationTitle("Add Workout")
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

    private func saveWorkout() {

        guard !exerciseName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter an exercise name."
            return
        }

        guard weight >= 0 else {
            errorMessage = "Weight cannot be negative."
            return
        }

        let workout = Workout(
            exerciseName: exerciseName,
            muscleGroup: muscleGroup.rawValue,
            sets: sets,
            reps: reps,
            weight: weight,
            notes: notes
        )

        modelContext.insert(workout)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            modelContext.delete(workout)
            errorMessage = "Unable to save workout. Please try again."
        }
    }
}

#Preview {
    AddWorkoutView()
        .modelContainer(for: Workout.self, inMemory: true)
}
