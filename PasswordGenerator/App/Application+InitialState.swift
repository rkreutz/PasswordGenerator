import Dependencies
import Foundation

extension Application {
    static func initialState() -> State {
        @Dependency(\.masterPasswordValidator) var masterPasswordValidator
        @Dependency(\.entropyConfigurationStorage) var entropyConfigurationStorage
        @Dependency(\.appConfigurationStorage) var appConfigurationStorage
        let derivationAlgorithm: AppConfiguration.KeyDerivationAlgorithm
        let iterations: UInt
        let memory: UInt
        let threads: UInt
        switch entropyConfigurationStorage.entropyGenerator() {
        case let .argon2(_iterations, _memory, _threads):
            derivationAlgorithm = .argon
            iterations = _iterations
            memory = _memory
            threads = _threads
        case let .pbkdf2(_iterations):
            derivationAlgorithm = .pbkdf
            iterations = _iterations
            memory = 0
            threads = 0
        }

        return State(
            isMasterPasswordSet: masterPasswordValidator.hasMasterPassword,
            tab: .generator,
            masterPassword: .init(),
            passwordGenerator: .init(
                configuration: .init(
                    passwordType: .domainBased,
                    domain: .init(
                        username: "",
                        domain: "",
                        seed: .init(
                            count: 1,
                            bounds: 1 ... 999
                        )
                    ),
                    service: .init(
                        service: ""
                    )
                ),
                length: .init(
                    count: 8,
                    bounds: 4 ... 32
                ),
                characters: .init(
                    digits: .init(
                        isToggled: true,
                        counter: .init(
                            count: 1,
                            bounds: 1 ... 8
                        )
                    ),
                    symbols: .init(
                        isToggled: false,
                        counter: .init(
                            count: 0,
                            bounds: 1 ... 8
                        )
                    ),
                    lowercase: .init(
                        isToggled: true,
                        counter: .init(
                            count: 1,
                            bounds: 1 ... 8
                        )
                    ),
                    uppercase: .init(
                        isToggled: true,
                        counter: .init(
                            count: 1,
                            bounds: 1 ... 8
                        )
                    ),
                    shouldUseOptimisedUI: appConfigurationStorage.shouldUseOptimisedUI
                ),
                password: .init(
                    flow: .invalid,
                    copyableContent: .init(
                        content: ""
                    )
                ),
                entropyGenerator: entropyConfigurationStorage.entropyGenerator(),
                entropySize: entropyConfigurationStorage.entropySize(),
                shouldUseOptimisedUI: appConfigurationStorage.shouldUseOptimisedUI,
                shouldShowPasswordStrength: appConfigurationStorage.shouldShowPasswordStrength
            ),
            configuration: AppConfiguration.State(
                derivationAlgorithm: derivationAlgorithm,
                iterations: iterations,
                memory: memory,
                threads: threads,
                entropySize: entropyConfigurationStorage.entropySize(),
                shouldShowPasswordStrength: appConfigurationStorage.shouldShowPasswordStrength,
                shouldUseOptimisedUI: appConfigurationStorage.shouldUseOptimisedUI,
                profilingState: .waiting
            )
        )
    }
}
