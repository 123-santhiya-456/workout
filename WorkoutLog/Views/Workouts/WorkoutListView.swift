
import SwiftUI
import SwiftData

struct WorkoutListView: View {

    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Workout.workoutDate, order: .reverse)
    private var workouts: [Workout]

    @State private var showingAddWorkout = false
    @State private var workoutToDelete: Workout?
    @State private var searchText = ""
    @State private var selectedMuscleGroup = "All"
    @State private var selectedSortOption = "Newest First"
    @State private var selectedDateFilter = "All Workouts"
    
    
    private var filteredWorkouts: [Workout] {

        let calendar = Calendar.current
        let now = Date()

        let filtered = workouts.filter { workout in

            // Search filter
            let matchesSearch =
                searchText.isEmpty ||
                workout.exerciseName.localizedCaseInsensitiveContains(searchText) ||
                workout.muscleGroup.localizedCaseInsensitiveContains(searchText)

            // Muscle group filter
            let matchesMuscleGroup =
                selectedMuscleGroup == "All" ||
                workout.muscleGroup == selectedMuscleGroup

            // Date filter
            let matchesDate: Bool

            switch selectedDateFilter {

            case "Today":
                matchesDate = calendar.isDateInToday(workout.workoutDate)

            case "This Week":
                if let interval = calendar.dateInterval(of: .weekOfYear, for: now) {
                    matchesDate = workout.workoutDate >= interval.start &&
                        workout.workoutDate < interval.end
                } else {
                    matchesDate = true
                }

            case "This Month":
                matchesDate = calendar.isDate(
                    workout.workoutDate,
                    equalTo: now,
                    toGranularity: .month
                )

            default:
                matchesDate = true
            }

            return matchesSearch && matchesMuscleGroup && matchesDate
        }

        // Existing sorting functionality
        switch selectedSortOption {

        case "Oldest First":
            return filtered.sorted {
                $0.workoutDate < $1.workoutDate
            }

        case "Exercise Name (A-Z)":
            return filtered.sorted {
                $0.exerciseName.localizedCaseInsensitiveCompare($1.exerciseName) == .orderedAscending
            }

        case "Highest Weight First":
            return filtered.sorted {
                $0.weight > $1.weight
            }

        default:
            return filtered.sorted {
                $0.workoutDate > $1.workoutDate
            }
        }
    }


    var body: some View {

        NavigationStack {

            Group {

                if filteredWorkouts.isEmpty {

                    ContentUnavailableView(
                        searchText.isEmpty ? "No Workouts Yet" : "No Matching Workouts",
                        systemImage: "dumbbell",
                        description: Text(
                            searchText.isEmpty
                            ? "Tap + to add your first workout."
                            : "Try searching for another exercise."
                        )
                    )

                } else {

                    List {
                        
                        Section {
                                Picker("Muscle Group", selection: $selectedMuscleGroup) {

                                    Text("All").tag("All")

                                    ForEach(MuscleGroup.allCases) { group in
                                        Text(group.rawValue).tag(group.rawValue)
                                    }
                                }
                            }
                        Section {
                            Picker("Sort By", selection: $selectedSortOption) {
                                Text("Newest First").tag("Newest First")
                                Text("Oldest First").tag("Oldest First")
                                Text("Exercise Name (A-Z)").tag("Exercise Name (A-Z)")
                                Text("Highest Weight First").tag("Highest Weight First")
                            }
                        }
                        Section("Workout History") {
                            Picker("Date Range", selection: $selectedDateFilter) {

                                Text("All Workouts").tag("All Workouts")
                                Text("Today").tag("Today")
                                Text("This Week").tag("This Week")
                                Text("This Month").tag("This Month")

                            }
                        }


                        ForEach(filteredWorkouts) { workout in

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

                                        Label(
                                            "\(workout.sets) Sets",
                                            systemImage: "repeat"
                                        )

                                        Label(
                                            "\(workout.reps) Reps",
                                            systemImage: "number"
                                        )

                                        Label(
                                            "\(workout.weight.formatted(.number.precision(.fractionLength(1)))) kg",
                                            systemImage: "scalemass"
                                        )
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                    Text(workout.workoutDate, style: .date)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 5)
                                .foregroundColor(.primary)
                            }
                        }
                        .onDelete(perform: deleteWorkout)
                    }
                }
            }
            .navigationTitle("My Workouts")
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddWorkout = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    if !workouts.isEmpty {
                        EditButton()
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView()
            }
            .searchable(
                text: $searchText,
                prompt: "Search exercises"
            )
            .alert(
                "Delete Workout?",
                isPresented: Binding(
                    get: { workoutToDelete != nil },
                    set: { if !$0 { workoutToDelete = nil } }
                )
            ) {

                Button("Cancel", role: .cancel) {
                    workoutToDelete = nil
                }

                Button("Delete", role: .destructive) {

                    if let workout = workoutToDelete {

                        modelContext.delete(workout)

                        do {
                            try modelContext.save()
                        } catch {
                            print("Delete failed: \(error.localizedDescription)")
                        }
                    }

                    workoutToDelete = nil
                }

            } message: {
                Text(
                    "Are you sure you want to delete this workout? This action cannot be undone."
                )
            }
        }
    }

    private func deleteWorkout(at offsets: IndexSet) {

        guard let index = offsets.first else { return }

        workoutToDelete = filteredWorkouts[index]
    }
}

#Preview {
    WorkoutListView()
        .modelContainer(for: Workout.self, inMemory: true)
}
