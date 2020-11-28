import Foundation
import ComposableArchitecture

extension PasswordGeneratorView.LengthView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CounterView.sharedReducer
            .pullback(
                state: \.lengthState,
                action: /Action.updatedLengthCounter,
                environment: { _ in CounterView.Environment() }
            ),
        Reducer { state, action, environment -> Effect<Action, Never> in

            .none
        }
    )
}
