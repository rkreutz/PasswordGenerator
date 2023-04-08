import Foundation
import PasswordGeneratorKit

extension PasswordGeneratorKit.PasswordGenerator.EntropyGenerator: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.argon2(lhsIterations, lhsMemory, lhsThreads), .argon2(rhsIterations, rhsMemory, rhsThreads)):
            return lhsIterations == rhsIterations && lhsMemory == rhsMemory && lhsThreads == rhsThreads
        case let (.pbkdf2(lhsIterations), .pbkdf2(rhsIterations)):
            return lhsIterations == rhsIterations
        default:
            return false
        }
    }
}
