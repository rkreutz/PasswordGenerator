import Foundation

extension PasswordGeneratorView.ConfigurationView {

    struct State: Equatable {

        var passwordType: PasswordGeneratorView.PasswordType
        var domainState: PasswordGeneratorView.DomainView.State
        var serviceState: PasswordGeneratorView.ServiceView.State
        var isValid: Bool
    }
}
