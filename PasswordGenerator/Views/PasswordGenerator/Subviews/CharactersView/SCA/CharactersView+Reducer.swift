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
            forActions: didUpdateDigitsCounter,
            didUpdateLowercaseCounter,
            didUpdateSymbolsCounter,
            didUpdateUppercaseCounter
        ) { state, _ -> Effect<Action, Never> in

            state.isValid = state.digitsState.isToggled
                || state.lowercaseState.isToggled
                || state.symbolsState.isToggled
                || state.uppercaseState.isToggled
            return Effect(value: Action.didUpdate)
        }
    )

    private static let didUpdateDigitsCounter = /Action.updateDigitsCounter .. /CounterToggleView.Action.didUpdate
    private static let didUpdateLowercaseCounter = /Action.updateLowercaseCounter .. /CounterToggleView.Action.didUpdate
    private static let didUpdateSymbolsCounter = /Action.updateSymbolsCounter .. /CounterToggleView.Action.didUpdate
    private static let didUpdateUppercaseCounter = /Action.updateUppercaseCounter .. /CounterToggleView.Action.didUpdate
}
