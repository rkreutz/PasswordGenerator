import Foundation
import PasswordGeneratorKit

extension AppConfigurationView {

    struct State: Equatable {

        static func == (lhs: AppConfigurationView.State, rhs: AppConfigurationView.State) -> Bool {
            lhs.entropyGenerator == rhs.entropyGenerator
            && lhs.entropySize == rhs.entropySize
            && lhs.error?.localizedDescription == rhs.error?.localizedDescription
        }

        var entropyGenerator: PasswordGenerator.EntropyGenerator
        var entropySize: UInt
        var error: Error?
    }
}

extension PasswordGenerator.EntropyGenerator: Equatable {
    
    public static func == (lhs: PasswordGenerator.EntropyGenerator, rhs: PasswordGenerator.EntropyGenerator) -> Bool {

        switch (lhs, rhs) {

        case let (.pbkdf2(lhsIterations), .pbkdf2(rhsIterations)):
            return lhsIterations == rhsIterations

        case let (.argon2(lhsIterations, lhsMemory, lhsThreads), .argon2(rhsIterations, rhsMemory, rhsThreads)):
            return lhsIterations == rhsIterations && lhsMemory == rhsMemory && lhsThreads == rhsThreads

        case (.pbkdf2, .argon2),
             (.argon2, .pbkdf2):
            return false
        }
    }
}
