import Foundation
import Combine
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
                return Just(Action.counterChanged(.counterUpdated(isToggled ? 1 : 0))).eraseToEffect()

            case .counterChanged:
                return .none
            }
        }
    )
}
