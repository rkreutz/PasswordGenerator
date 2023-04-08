import Dependencies
import Foundation
import PasswordGeneratorKit

protocol EntropyConfigurationStorage {

    func save(entropyGenerator: PasswordGeneratorKit.PasswordGenerator.EntropyGenerator)
    func save(entropySize: UInt)

    func entropyGenerator() -> PasswordGeneratorKit.PasswordGenerator.EntropyGenerator
    func entropySize() -> UInt
}

private enum EntropyConfigurationStorageKey: DependencyKey {
    static let liveValue: EntropyConfigurationStorage = UserDefaultsEntropyConfigurationStorage(userDefaults: .standard)
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
}

#endif
