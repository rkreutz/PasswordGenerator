import Foundation
import Combine
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
        Reducer { _, action, _ -> Effect<Action, Never> in

            switch action {

            case .updatedLengthCounter(.didUpdate):
                return Just(Action.didUpdate).eraseToEffect()

            default:
                return .none
            }
        }
    )
}
