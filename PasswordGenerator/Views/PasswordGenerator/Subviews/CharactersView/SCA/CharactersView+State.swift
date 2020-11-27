import Foundation

extension PasswordGeneratorView.CharactersView {

    struct State: Equatable {

        var digitsState: CounterToggleView.State
        var symbolsState: CounterToggleView.State
        var lowercaseState: CounterToggleView.State
        var uppercaseState: CounterToggleView.State
        var isValid: Bool
    }
}
