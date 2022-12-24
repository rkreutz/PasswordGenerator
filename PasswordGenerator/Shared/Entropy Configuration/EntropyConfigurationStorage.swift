import Foundation
import PasswordGeneratorKit

protocol EntropyConfigurationStorage {

    func save(entropyGenerator: PasswordGenerator.EntropyGenerator)
    func save(entropySize: UInt)

    func entropyGenerator() -> PasswordGenerator.EntropyGenerator
    func entropySize() -> UInt
}

#if DEBUG

final class MockEntropyConfigurationStorage: EntropyConfigurationStorage {

    private var _entropyGenerator: PasswordGenerator.EntropyGenerator = .argon2()
    private var _entropySize: UInt = 40

    func save(entropyGenerator: PasswordGenerator.EntropyGenerator) {

        self._entropyGenerator = entropyGenerator
    }

    func save(entropySize: UInt) {

        self._entropySize = entropySize
    }

    func entropyGenerator() -> PasswordGenerator.EntropyGenerator { self._entropyGenerator }
    func entropySize() -> UInt { self._entropySize }
}

#endif
