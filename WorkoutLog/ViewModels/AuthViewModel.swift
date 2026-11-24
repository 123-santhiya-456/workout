import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {

    private let biometricService = BiometricAuthServices()

    // Authentication status
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage = ""

    // Password login fields
    @Published var username = ""
    @Published var password = ""

    // Check Face ID availability
    var isBiometricAvailable: Bool {
        biometricService.isBiometricAvailable()
    }

    // MARK: - Face ID Authentication

    func authenticateWithBiometrics() async {
        isLoading = true
        errorMessage = ""

        let success = await biometricService.authenticate()

        if success {
            isAuthenticated = true
        } else {
            errorMessage = "Authentication failed. Please try again."
        }

        isLoading = false
    }

    // MARK: - Password Authentication

    func authenticateWithPassword() {

        errorMessage = ""

        if username.isEmpty || password.isEmpty {
            errorMessage = "Please enter username and password."
            return
        }

        // Temporary demo credentials
        if username == "admin" && password == "workout123" {
            isAuthenticated = true
        } else {
            errorMessage = "Invalid username or password."
        }
    }

    // Logout
    func logout() {
        isAuthenticated = false
        username = ""
        password = ""
        errorMessage = ""
    }
}
