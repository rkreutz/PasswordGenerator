import Foundation

extension AppConfigurationView {

    struct Environment {

        let entropyConfigurationStorage: EntropyConfigurationStorage
        let masterPasswordStorage: MasterPasswordStorage
    }
}

// MARK: Factories

extension AppConfigurationView.Environment {

    static func preview() -> Self {

        AppConfigurationView.Environment(
            entropyConfigurationStorage: UserDefaultsEntropyConfigurationStorage(userDefaults: .standard),
            masterPasswordStorage: MasterPasswordKeychain()
        )
    }
}
