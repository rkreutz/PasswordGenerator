import Foundation

extension PasswordGeneratorView {

    enum Action {

        case logout
        case didLogout
        case updatedConfigurationState(PasswordGeneratorView.ConfigurationView.Action)
        case updatedLengthState(PasswordGeneratorView.LengthView.Action)
        case updatedCharactersState(PasswordGeneratorView.CharactersView.Action)
        case updatedPasswordState(PasswordGeneratorView.PasswordView.Action)
        case updatedError(Error?)
    }
}
