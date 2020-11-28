import Foundation
import Combine
import ComposableArchitecture

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
        Reducer { state, action, _ -> Effect<Action, Never> in

            switch action {

            case .updateDigitsCounter(.didUpdate),
                 .updateLowercaseCounter(.didUpdate),
                 .updateSymbolsCounter(.didUpdate),
                 .updateUppercaseCounter(.didUpdate):
                state.isValid = state.digitsState.isToggled
                    || state.lowercaseState.isToggled
                    || state.symbolsState.isToggled
                    || state.uppercaseState.isToggled
                return Just(Action.didUpdate).eraseToEffect()

            default:
                return .none
            }
        }
    )
}
