import Foundation
import ComposableArchitecture

extension CounterToggleView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CounterView.sharedReducer
            .pullback(
                state: \.counterState,
                action: /Action.counterChanged,
                environment: { _ in CounterView.Environment() }
            ),
        Reducer { state, action, _ -> Effect<Action, Never> in

            switch action {

            case let .toggleChanged(isToggled):
                state.isToggled = isToggled
                state.counterState.count = isToggled ? 1 : 0
                return .none

            case .counterChanged:
                return .none
            }
        }
    )
}
