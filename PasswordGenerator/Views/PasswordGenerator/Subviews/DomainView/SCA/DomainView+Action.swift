import Foundation

extension PasswordGeneratorView.DomainView {

    enum Action {

        case updateUsername(String)
        case updateDomain(String)
        case updateSeed(CounterView.Action)
        case didUpdate
    }
}
