import Foundation

extension PasswordGeneratorApp {

    static func initialState(environment: Environment) -> State {
        State(
            isMasterPasswordSet: environment.masterPasswordValidator.hasMasterPassword,
            masterPasswordState: .init(),
            passwordGeneratorState: .init(
                configurationState: .init(
                    passwordType: .domainBased,
                    domainState: .init(
                        username: "",
                        domain: "",
                        seed: .init(
                            title: Strings.PasswordGeneratorView.seed.formatted(),
                            count: 1,
                            bounds: 1 ... 999
                        ),
                        isValid: false
                    ),
                    serviceState: .init(
                        service: "",
                        isValid: false
                    ),
                    isValid: false
                ),
                lengthState: .init(
                    lengthState: .init(
                        title: Strings.PasswordGeneratorView.passwordLength.formatted(),
                        count: 8,
                        bounds: 4 ... 32
                    )
                ),
                charactersState: .init(
                    digitsState: .init(
                        toggleTitle: Strings.PasswordGeneratorView.decimalCharacters.formatted(),
                        isToggled: true,
                        counterState: .init(
                            title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                            count: 1,
                            bounds: 1 ... 8
                        )
                    ),
                    symbolsState: .init(
                        toggleTitle: Strings.PasswordGeneratorView.symbolsCharacters.formatted(),
                        isToggled: false,
                        counterState: .init(
                            title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                            count: 1,
                            bounds: 1 ... 8
                        )
                    ),
                    lowercaseState: .init(
                        toggleTitle: Strings.PasswordGeneratorView.lowercasedCharacters.formatted(),
                        isToggled: true,
                        counterState: .init(
                            title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                            count: 1,
                            bounds: 1 ... 8
                        )
                    ),
                    uppercaseState: .init(
                        toggleTitle: Strings.PasswordGeneratorView.uppercasedCharacters.formatted(),
                        isToggled: true,
                        counterState: .init(
                            title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                            count: 1,
                            bounds: 1 ... 8
                        )
                    ),
                    isValid: true
                ),
                passwordState: .init(
                    flow: .invalid,
                    copyableState: .init(content: "")
                ),
                entropyGenerator: environment.entropyConfigurationStorage.entropyGenerator(),
                entropySize: environment.entropyConfigurationStorage.entropySize()
            ),
            configurationState: .init(
                entropyGenerator: environment.entropyConfigurationStorage.entropyGenerator(),
                entropySize: environment.entropyConfigurationStorage.entropySize()
            )
        )
    }
}
