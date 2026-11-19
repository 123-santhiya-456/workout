
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {

            Image(systemName: "dumbbell.fill")
                .font(.system(size: 70))
                .foregroundColor(.blue)

            Text("WorkoutLog")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Your Fitness Journey Starts Here!")
                .font(.headline)
                .foregroundColor(.secondary)

            Button(action: {
                print("WorkoutLog App is Working!")
            }) {
                Text("Get Started")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding(25)
    }
}

#Preview {
    ContentView()
}
