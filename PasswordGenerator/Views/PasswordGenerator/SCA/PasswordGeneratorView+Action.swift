import Foundation

extension PasswordGeneratorView {

    enum Action {

        case didLogout
        case updatedConfigurationState(PasswordGeneratorView.ConfigurationView.Action)
        case updatedLengthState(PasswordGeneratorView.LengthView.Action)
        case updatedCharactersState(PasswordGeneratorView.CharactersView.Action)
        case updatedPasswordState(PasswordGeneratorView.PasswordView.Action)
        case updateError(Error?)
    }
}
