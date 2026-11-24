import SwiftUI

struct AuthenticationView: View {

    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 22) {

            Spacer()

            // App Logo
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("WorkoutLog")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Your fitness journey starts here")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            // Username Field
            TextField("Username", text: $authViewModel.username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            // Password Field
            SecureField("Password", text: $authViewModel.password)
                .textFieldStyle(.roundedBorder)

            // Password Login Button
            Button {
                authViewModel.authenticateWithPassword()
            } label: {
                Text("Login")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }

            // OR Divider
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))

                Text("OR")
                    .foregroundColor(.secondary)

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
            }

            // Face ID Button
            Button {
                Task {
                    await authViewModel.authenticateWithBiometrics()
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "faceid")
                        .font(.title2)

                    Text("Continue with Face ID")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 1.5)
                }
            }
            .disabled(!authViewModel.isBiometricAvailable ||
                      authViewModel.isLoading)

            // Loading Indicator
            if authViewModel.isLoading {
                ProgressView("Authenticating...")
            }

            // Error Message
            if !authViewModel.errorMessage.isEmpty {
                Text(authViewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding(25)
        .fullScreenCover(isPresented: $authViewModel.isAuthenticated) {
                    DashboardView()
                }
    }
}

#Preview {
    AuthenticationView()
}
