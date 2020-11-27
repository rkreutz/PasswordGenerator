import Foundation

extension PasswordGeneratorView.CharactersView {

    enum Action {

        case updatedDigitsCounter(CounterToggleView.Action)
        case updatedLowercaseCounter(CounterToggleView.Action)
        case updatedUppercaseCounter(CounterToggleView.Action)
        case updatedSymbolsCounter(CounterToggleView.Action)
        case updatedValidity(Bool)
    }
}
