import Foundation

extension PasswordGeneratorApp {

    enum Action {

        case updatedMasterPassword(MasterPasswordView.Action)
        case updatedPasswordGenerator(PasswordGeneratorView.Action)
        case updatedConfiguration(AppConfigurationView.Action)
    }
}
