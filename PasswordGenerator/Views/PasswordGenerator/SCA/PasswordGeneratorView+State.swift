import Foundation

extension PasswordGeneratorView {

    struct State: Equatable {

        var configurationState: ConfigurationView.State
        var lengthState: LengthView.State
        var charactersState: CharactersView.State
        var passwordState: PasswordView.State
        var error: Error?

        static func == (lhs: PasswordGeneratorView.State, rhs: PasswordGeneratorView.State) -> Bool {

            lhs.configurationState == rhs.configurationState
            && lhs.lengthState == rhs.lengthState
            && lhs.charactersState == rhs.charactersState
            && lhs.passwordState == rhs.passwordState
            && lhs.error?.localizedDescription == rhs.error?.localizedDescription
        }
    }
}
