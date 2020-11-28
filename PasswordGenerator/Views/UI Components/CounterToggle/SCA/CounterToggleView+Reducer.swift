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

            case let .updateToggle(isToggled):
                state.isToggled = isToggled
                return Just(Action.didUpdate).eraseToEffect()

            case .counterChanged(.didUpdate):
                return Just(Action.didUpdate).eraseToEffect()

            case .counterChanged(.update),
                 .didUpdate:
                return .none
            }
        }
    )
}
