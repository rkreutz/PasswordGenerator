import Foundation

extension PasswordGeneratorView.DomainView {

    struct State: Equatable {

        var username: String
        var domain: String
        var seed: CounterView.State
        var isValid: Bool
    }
}
