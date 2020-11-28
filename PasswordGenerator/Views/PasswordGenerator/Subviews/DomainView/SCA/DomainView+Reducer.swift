import Foundation
import ComposableArchitecture
import Combine

extension PasswordGeneratorView.DomainView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CounterView.sharedReducer
            .pullback(
                state: \.seed,
                action: /Action.updateSeed,
                environment: { _ in CounterView.Environment() }
            ),

        Reducer { state, action, _ -> Effect<Action, Never> in

            func isStateValid(_ state: State) -> Bool {

                let isValidDomain = state.domain.hasMatchingTypes(NSTextCheckingResult.CheckingType.link.rawValue)
                let isValidUsername = state.username.isNotEmpty
                return isValidDomain && isValidUsername
            }

            switch action {

            case let .updateDomain(domain):
                state.domain = domain
                state.isValid = isStateValid(state)
                return Just(Action.didUpdate).eraseToEffect()

            case let .updateUsername(username):
                state.username = username
                state.isValid = isStateValid(state)
                return Just(Action.didUpdate).eraseToEffect()

            case .updateSeed(.didUpdate):
                return Just(Action.didUpdate).eraseToEffect()

            default:
                return .none
            }
        }
    )
}
