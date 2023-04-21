import Combine
import Dependencies
import Foundation
import PasswordGeneratorKit

protocol EntropyConfigurationStorage {

    func save(entropyGenerator: PasswordGeneratorKit.PasswordGenerator.EntropyGenerator)
    func save(entropySize: UInt)

    func entropyGenerator() -> PasswordGeneratorKit.PasswordGenerator.EntropyGenerator
    func entropySize() -> UInt

    func configurationChanges() -> AnyPublisher<EntropyConfigurationStorageChange, Never>
}

enum EntropyConfigurationStorageChange {
    case entropySize(UInt)
    case entropyGenerator(PasswordGeneratorKit.PasswordGenerator.EntropyGenerator)
    case entropyGeneratorIterations(UInt)
    case entropyGeneratorMemory(UInt)
    case entropyGeneratorThreads(UInt)
}

private enum EntropyConfigurationStorageKey: DependencyKey {
    static let liveValue: EntropyConfigurationStorage = UbiquitousEntropyConfigurationStorage(
        keyStore: .default,
        localStorage: UserDefaultsEntropyConfigurationStorage(userDefaults: .standard),
        notificationCenter: .default
    )
#if DEBUG
    static let previewValue: EntropyConfigurationStorage = MockEntropyConfigurationStorage()
    static let testValue: EntropyConfigurationStorage = MockEntropyConfigurationStorage()
#endif
}

extension DependencyValues {
    var entropyConfigurationStorage: EntropyConfigurationStorage {
        get { self[EntropyConfigurationStorageKey.self] }
        set { self[EntropyConfigurationStorageKey.self] = newValue }
    }
}

#if DEBUG

final class MockEntropyConfigurationStorage: EntropyConfigurationStorage {

    private var _entropyGenerator: PasswordGeneratorKit.PasswordGenerator.EntropyGenerator = .argon2()
    private var _entropySize: UInt = 40

    func save(entropyGenerator: PasswordGeneratorKit.PasswordGenerator.EntropyGenerator) {

        self._entropyGenerator = entropyGenerator
    }

    func save(entropySize: UInt) {

        self._entropySize = entropySize
    }

    func entropyGenerator() -> PasswordGeneratorKit.PasswordGenerator.EntropyGenerator { self._entropyGenerator }
    func entropySize() -> UInt { self._entropySize }

    func configurationChanges() -> AnyPublisher<EntropyConfigurationStorageChange, Never> { Empty().eraseToAnyPublisher() }
}

#endif
