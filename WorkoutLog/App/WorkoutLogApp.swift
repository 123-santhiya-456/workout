
import SwiftUI
import SwiftData

@main
struct WorkoutLogApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Workout.self)
    }
}
