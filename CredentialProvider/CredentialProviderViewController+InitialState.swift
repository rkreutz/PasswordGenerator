import Foundation

extension CredentialProviderViewController {

    static let initialState = PasswordGenerator.State(
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
            )
        ),
        password: .init(
            flow: .invalid,
            copyableContent: .init(content: "")
        ),
        entropyGenerator: UserDefaultsEntropyConfigurationStorage(userDefaults: .standard).entropyGenerator(),
        entropySize: UserDefaultsEntropyConfigurationStorage(userDefaults: .standard).entropySize()
    )
}
