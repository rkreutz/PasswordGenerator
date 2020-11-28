import Foundation

extension PasswordGeneratorView.ConfigurationView {

    enum Action {

        case updatePasswordType(PasswordType)
        case updateDomain(PasswordGeneratorView.DomainView.Action)
        case updateService(PasswordGeneratorView.ServiceView.Action)
        case didUpdate
    }
}
