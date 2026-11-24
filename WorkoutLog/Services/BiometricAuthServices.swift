import Foundation
import LocalAuthentication

class BiometricAuthServices {

    // Check whether Face ID or Touch ID is available
    func isBiometricAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?

        return context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        )
    }

    // Authenticate the user using biometrics
    func authenticate() async -> Bool {
        let context = LAContext()
        var error: NSError?

        // Check biometric availability
        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            print("Biometric authentication is not available.")
            return false
        }

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Authenticate to access WorkoutLog"
            )

            return success

        } catch {
            print("Authentication failed: \(error.localizedDescription)")
            return false
        }
    }
}
