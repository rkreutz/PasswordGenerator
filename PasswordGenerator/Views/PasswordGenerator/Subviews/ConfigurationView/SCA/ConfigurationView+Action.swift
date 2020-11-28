import Foundation

extension PasswordGeneratorView.ConfigurationView {

    enum Action {

        case updatedPasswordType(PasswordGeneratorView.PasswordType)
        case updatedDomain(PasswordGeneratorView.DomainView.Action)
        case updatedService(PasswordGeneratorView.ServiceView.Action)
        case updatedValidity(Bool)
    }
}
