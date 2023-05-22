import Foundation
import PasswordGeneratorKit

enum Defaults {
    
    static let entropyGenerator = PasswordGeneratorKit.PasswordGenerator.EntropyGenerator.pbkdf2(iterations: PBKDF2.iterations)
    static let entropySize: UInt = 40

    enum PBKDF2 {

        static let iterations: UInt = 1_000
    }

    enum Argon2 {

        static let iterations: UInt = 3
        static let memory: UInt = 16_384
        static let threads: UInt = 1
    }

    enum Entropy {

        static let max: Double = 32.0 * log2(73.0)
        static let low: Double = 60.0
        static let recommended: Double = 80.0
        static let great: Double = 100.0
    }
}
