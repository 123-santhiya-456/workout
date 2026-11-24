//
//  MuscleGroup.swift
//  WorkoutLog
//
//  Created by KCEMAC12 on 19/11/26.
//


import Foundation

enum MuscleGroup: String, CaseIterable, Identifiable {

    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case biceps = "Biceps"
    case triceps = "Triceps"
    case abs = "Abs"
    case cardio = "Cardio"

    var id: String {
        self.rawValue
    }
}
