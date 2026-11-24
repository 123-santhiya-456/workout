
import SwiftUI
import SwiftData

struct DashboardView: View {

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            DashboardContentView(modelContext: modelContext)
        }
    }
}

private struct DashboardContentView: View {

    @StateObject private var viewModel: DashboardViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(
            wrappedValue: DashboardViewModel(modelContext: modelContext)
        )
    }

    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: 25) {

                // Welcome Section
                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Ready for your next workout?")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Statistics Section
                VStack(alignment: .leading, spacing: 15) {

                    Text("Your Activity")
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack(spacing: 12) {
                        StatCard(
                            title: "Workouts",
                            value: "\(viewModel.totalWorkouts)",
                            icon: "dumbbell.fill"
                        )

                        StatCard(
                            title: "This Week",
                            value: "\(viewModel.workoutsThisWeek)",
                            icon: "calendar"
                        )
                    }

                    HStack(spacing: 12) {
                        StatCard(
                            title: "Total Sets",
                            value: "\(viewModel.totalSets)",
                            icon: "figure.strengthtraining.traditional"
                        )

                        NavigationLink(destination: PersonalBestView()) {
                            StatCard(
                                title: "Personal Bests",
                                value: "\(viewModel.personalBests)",
                                icon: "trophy.fill"
                            )
                        }
                        .buttonStyle(.plain)                    }
                }

                // My Workouts Navigation
                NavigationLink(destination: WorkoutListView()) {
                    HStack {
                        Image(systemName: "dumbbell.fill")
                            .font(.title2)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("My Workouts")
                                .font(.headline)

                            Text("View and manage your workouts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(15)
                }
                // Recent Workouts
                VStack(alignment: .leading, spacing: 15) {

                    Text("Recent Workouts")
                        .font(.title2)
                        .fontWeight(.bold)

                    if viewModel.recentWorkouts.isEmpty {

                        VStack(spacing: 10) {
                            Image(systemName: "dumbbell")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)

                            Text("No workouts yet")
                                .font(.headline)

                            Text("Your workout history will appear here.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(30)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)

                    } else {

                        ForEach(viewModel.recentWorkouts) { workout in

                            NavigationLink {
                                WorkoutDetailView(workout: workout)
                            } label: {

                                VStack(alignment: .leading, spacing: 8) {

                                    Text(workout.exerciseName)
                                        .font(.headline)

                                    Text(workout.muscleGroup)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)

                                    HStack {
                                        Label("\(workout.sets) Sets", systemImage: "repeat")

                                        Label("\(workout.reps) Reps", systemImage: "number")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                    Text(workout.workoutDate, style: .date)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                                .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .onAppear {
            viewModel.calculateStatistics()
        }
    }
}

// Reusable Statistics Card
struct StatCard: View {

    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)

            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: Workout.self, inMemory: true)
}
