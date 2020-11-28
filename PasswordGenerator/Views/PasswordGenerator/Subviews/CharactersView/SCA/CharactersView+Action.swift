import Foundation

extension PasswordGeneratorView.CharactersView {

    enum Action {

        case updateDigitsCounter(CounterToggleView.Action)
        case updateLowercaseCounter(CounterToggleView.Action)
        case updateUppercaseCounter(CounterToggleView.Action)
        case updateSymbolsCounter(CounterToggleView.Action)
        case didUpdate
    }
}
