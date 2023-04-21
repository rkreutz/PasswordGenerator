import Combine
import Foundation
import PasswordGeneratorKit

final class UserDefaultsEntropyConfigurationStorage: EntropyConfigurationStorage {

    enum Constants {

        static let pbkdf2 = "PBKDF2"
        static let argon2 = "Argon2"
        static let entropyGeneratorKey = "entropy_generator_type"
        static let iterationsKey = "entropy_generator_iterations"
        static let memoryKey = "entropy_generator_memory"
        static let threadsKey = "entropy_generator_threads"
        static let bytesKey = "entropy_generator_entropy_size"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {

        self.userDefaults = userDefaults
    }

    func save(entropyGenerator: PasswordGeneratorKit.PasswordGenerator.EntropyGenerator) {

        switch entropyGenerator {

        case let .pbkdf2(iterations):
            userDefaults.set(Constants.pbkdf2, forKey: Constants.entropyGeneratorKey)
            userDefaults.set(iterations, forKey: Constants.iterationsKey)
            userDefaults.removeObject(forKey: Constants.memoryKey)
            userDefaults.removeObject(forKey: Constants.threadsKey)

        case let .argon2(iterations, memory, threads):
            userDefaults.set(Constants.argon2, forKey: Constants.entropyGeneratorKey)
            userDefaults.set(iterations, forKey: Constants.iterationsKey)
            userDefaults.set(memory, forKey: Constants.memoryKey)
            userDefaults.set(threads, forKey: Constants.threadsKey)
        }

        userDefaults.synchronize()
    }

    func save(entropySize: UInt) {

        userDefaults.set(entropySize, forKey: Constants.bytesKey)
    }

    func entropyGenerator() -> PasswordGeneratorKit.PasswordGenerator.EntropyGenerator {

        switch userDefaults.value(forKey: Constants.entropyGeneratorKey) as? String {

        case Constants.pbkdf2:
            let storedIterations = UInt(userDefaults.integer(forKey: Constants.iterationsKey))
            return .pbkdf2(iterations: storedIterations > 0 ? storedIterations : Defaults.PBKDF2.iterations)

        case Constants.argon2:
            let storedIterations = UInt(userDefaults.integer(forKey: Constants.iterationsKey))
            let storedMemory = UInt(userDefaults.integer(forKey: Constants.memoryKey))
            let storedThreads = UInt(userDefaults.integer(forKey: Constants.threadsKey))
            return .argon2(
                iterations: storedIterations > 0 ? storedIterations : Defaults.Argon2.iterations,
                memory: storedMemory > 0 ? storedMemory : Defaults.Argon2.memory,
                threads: storedThreads > 0 ? storedThreads : Defaults.Argon2.threads
            )

        default:
            return Defaults.entropyGenerator
        }
    }

    func entropySize() -> UInt {

        let storedSize = UInt(userDefaults.integer(forKey: Constants.bytesKey))
        return storedSize > 0 ? storedSize : Defaults.entropySize
    }

    func configurationChanges() -> AnyPublisher<EntropyConfigurationStorageChange, Never> { Empty().eraseToAnyPublisher() }
}
