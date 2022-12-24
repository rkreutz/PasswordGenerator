import Foundation
import PasswordGeneratorKit

enum Defaults {
    
    static let entropyGenerator = PasswordGenerator.EntropyGenerator.pbkdf2(iterations: PBKDF2.iterations)
    static let entropySize: UInt = 40

    enum PBKDF2 {

        static let iterations: UInt = 1_000
    }

    enum Argon2 {

        static let iterations: UInt = 3
        static let memory: UInt = 16_384
        static let threads: UInt = 1
    }
}
