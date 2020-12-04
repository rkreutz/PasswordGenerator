import Foundation
import ComposableArchitecture
import CasePaths

extension PasswordGeneratorView.CharactersView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CounterToggleView.sharedReducer
            .pullback(
                state: \.digitsState,
                action: /Action.updateDigitsCounter,
                environment: { _ in CounterToggleView.Environment() }
            ),
        CounterToggleView.sharedReducer
            .pullback(
                state: \.lowercaseState,
                action: /Action.updateLowercaseCounter,
                environment: { _ in CounterToggleView.Environment() }
            ),
        CounterToggleView.sharedReducer
            .pullback(
                state: \.uppercaseState,
                action: /Action.updateUppercaseCounter,
                environment: { _ in CounterToggleView.Environment() }
            ),
        CounterToggleView.sharedReducer
            .pullback(
                state: \.symbolsState,
                action: /Action.updateSymbolsCounter,
                environment: { _ in CounterToggleView.Environment() }
            ),
        Reducer(
            forActions: .didUpdateDigitsCounter,
            .didUpdateLowercaseCounter,
            .didUpdateSymbolsCounter,
            .didUpdateUppercaseCounter
        ) { state, _ -> Effect<Action, Never> in

            state.isValid = state.digitsState.isToggled
                || state.lowercaseState.isToggled
                || state.symbolsState.isToggled
                || state.uppercaseState.isToggled
            return Effect(value: Action.didUpdate)
        }
    )
}

private extension CasePath where Root == PasswordGeneratorView.CharactersView.Action, Value == Void {

    static let didUpdateDigitsCounter =
        /PasswordGeneratorView.CharactersView.Action.updateDigitsCounter
        .. /CounterToggleView.Action.didUpdate

    static let didUpdateLowercaseCounter =
        /PasswordGeneratorView.CharactersView.Action.updateLowercaseCounter
        .. /CounterToggleView.Action.didUpdate

    static let didUpdateSymbolsCounter =
        /PasswordGeneratorView.CharactersView.Action.updateSymbolsCounter
        .. /CounterToggleView.Action.didUpdate

    static let didUpdateUppercaseCounter =
        /PasswordGeneratorView.CharactersView.Action.updateUppercaseCounter
        .. /CounterToggleView.Action.didUpdate
}
