import Combine
import ComposableArchitecture
import Foundation
import PasswordGeneratorKit

final class UbiquitousEntropyConfigurationStorage: EntropyConfigurationStorage {

    enum Constants {

        static let pbkdf2 = "PBKDF2"
        static let argon2 = "Argon2"
        static let entropyGeneratorKey = "entropy_generator_type"
        static let iterationsKey = "entropy_generator_iterations"
        static let memoryKey = "entropy_generator_memory"
        static let threadsKey = "entropy_generator_threads"
        static let bytesKey = "entropy_generator_entropy_size"
        static let wasMigrated = "migrated"
    }

    private let keyStore: NSUbiquitousKeyValueStore
    private let notificationCenter: NotificationCenter

    init(
        keyStore: NSUbiquitousKeyValueStore,
        localStorage: UserDefaultsEntropyConfigurationStorage,
        notificationCenter: NotificationCenter
    ) {
        self.keyStore = keyStore
        self.notificationCenter = notificationCenter
        keyStore.synchronize()
        migrateIfNeeded(from: localStorage)
    }

    func save(entropyGenerator: PasswordGeneratorKit.PasswordGenerator.EntropyGenerator) {
        switch entropyGenerator {

        case let .pbkdf2(iterations):
            keyStore.set(Constants.pbkdf2, forKey: Constants.entropyGeneratorKey)
            keyStore.set(iterations, forKey: Constants.iterationsKey)
            keyStore.removeObject(forKey: Constants.memoryKey)
            keyStore.removeObject(forKey: Constants.threadsKey)

        case let .argon2(iterations, memory, threads):
            keyStore.set(Constants.argon2, forKey: Constants.entropyGeneratorKey)
            keyStore.set(iterations, forKey: Constants.iterationsKey)
            keyStore.set(memory, forKey: Constants.memoryKey)
            keyStore.set(threads, forKey: Constants.threadsKey)
        }

        keyStore.synchronize()
    }

    func save(entropySize: UInt) {
        keyStore.set(entropySize, forKey: Constants.bytesKey)
        keyStore.synchronize()
    }

    func entropyGenerator() -> PasswordGeneratorKit.PasswordGenerator.EntropyGenerator {

        switch keyStore.object(forKey: Constants.entropyGeneratorKey) as? String {

        case Constants.pbkdf2:
            let storedIterations = keyStore.object(forKey: Constants.iterationsKey) as? UInt ?? 0
            return .pbkdf2(iterations: storedIterations > 0 ? storedIterations : Defaults.PBKDF2.iterations)

        case Constants.argon2:
            let storedIterations = keyStore.object(forKey: Constants.iterationsKey) as? UInt ?? 0
            let storedMemory = keyStore.object(forKey: Constants.memoryKey) as? UInt ?? 0
            let storedThreads = keyStore.object(forKey: Constants.threadsKey) as? UInt ?? 0
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
        let storedSize = keyStore.object(forKey: Constants.bytesKey) as? UInt ?? 0
        return storedSize > 0 ? storedSize : Defaults.entropySize
    }

    func configurationChanges() -> AnyPublisher<EntropyConfigurationStorageChange, Never> {
        notificationCenter.publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
            .flatMap { [unowned self] notification -> AnyPublisher<EntropyConfigurationStorageChange, Never> in
                guard
                    notification.userInfo?[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int == NSUbiquitousKeyValueStoreServerChange,
                    let keys = notification.userInfo?[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String]
                else { return Empty().eraseToAnyPublisher() }

                let sizePublisher: AnyPublisher<EntropyConfigurationStorageChange, Never>
                if keys.contains(Constants.bytesKey) {
                    sizePublisher = Just(.entropySize(entropySize())).eraseToAnyPublisher()
                } else {
                    sizePublisher = Empty().eraseToAnyPublisher()
                }

                let generatorPublisher: AnyPublisher<EntropyConfigurationStorageChange, Never>
                if keys.contains(Constants.entropyGeneratorKey) {
                    switch keyStore.object(forKey: Constants.entropyGeneratorKey) as? String {
                    case Constants.pbkdf2:
                        generatorPublisher = Just(
                            .entropyGenerator(
                                .pbkdf2(
                                    iterations: keyStore.object(forKey: Constants.iterationsKey) as? UInt ?? Defaults.PBKDF2.iterations
                                )
                            )
                        ).eraseToAnyPublisher()

                    case Constants.argon2:
                        generatorPublisher = Just(
                            .entropyGenerator(
                                .argon2(
                                    iterations: keyStore.object(forKey: Constants.iterationsKey) as? UInt ?? Defaults.Argon2.iterations,
                                    memory: keyStore.object(forKey: Constants.memoryKey) as? UInt ?? Defaults.Argon2.memory,
                                    threads: keyStore.object(forKey: Constants.threadsKey) as? UInt ?? Defaults.Argon2.threads
                                )
                            )
                        ).eraseToAnyPublisher()

                    default:
                        generatorPublisher = Empty().eraseToAnyPublisher()
                    }
                } else {
                    generatorPublisher = keys
                        .compactMap { key -> AnyPublisher<EntropyConfigurationStorageChange, Never>? in
                            switch key {
                            case Constants.iterationsKey:
                                guard let iterations = keyStore.object(forKey: Constants.iterationsKey) as? UInt else { return nil }
                                return Just(.entropyGeneratorIterations(iterations)).eraseToAnyPublisher()
                            case Constants.memoryKey:
                                guard let memory = keyStore.object(forKey: Constants.memoryKey) as? UInt else { return nil }
                                return Just(.entropyGeneratorMemory(memory)).eraseToAnyPublisher()
                            case Constants.threadsKey:
                                guard let threads = keyStore.object(forKey: Constants.threadsKey) as? UInt else { return nil }
                                return Just(.entropyGeneratorThreads(threads)).eraseToAnyPublisher()
                            default:
                                return nil
                            }
                        }
                        .merge()
                }

                return Publishers.Merge(sizePublisher, generatorPublisher).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

private extension UbiquitousEntropyConfigurationStorage {

    func migrateIfNeeded(from localStorage: UserDefaultsEntropyConfigurationStorage) {
        guard keyStore.bool(forKey: Constants.wasMigrated) == false else { return }

        defer {
            keyStore.set(true, forKey: Constants.wasMigrated)
            keyStore.synchronize()
        }
        guard localStorage.entropyGenerator() != Defaults.entropyGenerator || localStorage.entropySize() != Defaults.entropySize else { return }

        save(entropyGenerator: localStorage.entropyGenerator())
        save(entropySize: localStorage.entropySize())
    }
}

private extension Array where Element: Publisher {
    func merge() -> AnyPublisher<Element.Output, Element.Failure> {
        Publishers.MergeMany(self).eraseToAnyPublisher()
    }
}
