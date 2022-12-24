import Foundation

extension PasswordGeneratorApp {

    struct State: Equatable {

        var isMasterPasswordSet: Bool
        var masterPasswordState: MasterPasswordView.State
        var passwordGeneratorState: PasswordGeneratorView.State
        var configurationState: AppConfigurationView.State
    }
}
