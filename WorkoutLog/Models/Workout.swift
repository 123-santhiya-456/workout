//
//  Workout.swift
//  WorkoutLog
//
//  Created by KCEMAC12 on 19/11/26.
//


import Foundation
import SwiftData

@Model
final class Workout {

    var id: UUID
    var exerciseName: String
    var muscleGroup: String
    var sets: Int
    var reps: Int
    var weight: Double
    var workoutDate: Date
    var notes: String

    init(
        exerciseName: String,
        muscleGroup: String,
        sets: Int,
        reps: Int,
        weight: Double,
        workoutDate: Date = Date(),
        notes: String = ""
    ) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.workoutDate = workoutDate
        self.notes = notes
    }
}
