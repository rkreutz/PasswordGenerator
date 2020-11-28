import Foundation

extension PasswordGeneratorView.DomainView {

    enum Action {

        case updatedUsername(String)
        case updatedDomain(String)
        case updatedSeed(CounterView.Action)
        case updatedValidity(Bool)
    }
}
