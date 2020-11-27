import Foundation
import Combine
import ComposableArchitecture

extension PasswordGeneratorView.CharactersView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CounterToggleView.sharedReducer
            .pullback(
                state: \.digitsState,
                action: /Action.updatedDigitsCounter,
                environment: { _ in CounterToggleView.Environment() }
            ),
        CounterToggleView.sharedReducer
            .pullback(
                state: \.lowercaseState,
                action: /Action.updatedLowercaseCounter,
                environment: { _ in CounterToggleView.Environment() }
            ),
        CounterToggleView.sharedReducer
            .pullback(
                state: \.uppercaseState,
                action: /Action.updatedUppercaseCounter,
                environment: { _ in CounterToggleView.Environment() }
            ),
        CounterToggleView.sharedReducer
            .pullback(
                state: \.symbolsState,
                action: /Action.updatedSymbolsCounter,
                environment: { _ in CounterToggleView.Environment() }
            ),
        Reducer { state, action, _ -> Effect<Action, Never> in

            switch action {

            case .updatedDigitsCounter(.toggleChanged(true)) where !state.isValid,
                 .updatedSymbolsCounter(.toggleChanged(true)) where !state.isValid,
                 .updatedUppercaseCounter(.toggleChanged(true)) where !state.isValid,
                 .updatedLowercaseCounter(.toggleChanged(true)) where !state.isValid:
                return Just(Action.updatedValidity(true)).eraseToEffect()

            //swiftlint:disable line_length
            case .updatedDigitsCounter(.toggleChanged(false)) where state.isValid && !state.uppercaseState.isToggled && !state.lowercaseState.isToggled && !state.symbolsState.isToggled,
                 .updatedLowercaseCounter(.toggleChanged(false)) where state.isValid && !state.uppercaseState.isToggled && !state.symbolsState.isToggled && !state.digitsState.isToggled,
                 .updatedUppercaseCounter(.toggleChanged(false)) where state.isValid && !state.symbolsState.isToggled && !state.lowercaseState.isToggled && !state.digitsState.isToggled,
                 .updatedSymbolsCounter(.toggleChanged(false)) where state.isValid && !state.uppercaseState.isToggled && !state.lowercaseState.isToggled && !state.digitsState.isToggled:
            //swiftlint:enable line_length
                return Just(Action.updatedValidity(false)).eraseToEffect()

            case let .updatedValidity(isValid):
                state.isValid = isValid
                return .none

            default:
                return .none
            }
        }
    )
}
