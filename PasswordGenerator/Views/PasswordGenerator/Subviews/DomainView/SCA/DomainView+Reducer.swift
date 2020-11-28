import Foundation
import ComposableArchitecture
import Combine

extension PasswordGeneratorView.DomainView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CounterView.sharedReducer
            .pullback(
                state: \.seed,
                action: /Action.updatedSeed,
                environment: { _ in CounterView.Environment() }
            ),

        Reducer { state, action, _ -> Effect<Action, Never> in

            func isStateValid(_ state: State) -> Bool {

                let isValidDomain = state.domain.hasMatchingTypes(NSTextCheckingResult.CheckingType.link.rawValue)
                let isValidUsername = state.username.isNotEmpty
                return isValidDomain && isValidUsername
            }

            switch action {

            case let .updatedDomain(domain):
                state.domain = domain
                let isValid = isStateValid(state)
                if state.isValid != isValid {

                    return Just(Action.updatedValidity(isValid)).eraseToEffect()
                } else {

                    return .none
                }

            case let .updatedUsername(username):
                state.username = username
                let isValid = isStateValid(state)
                if state.isValid != isValid {

                    return Just(Action.updatedValidity(isValid)).eraseToEffect()
                } else {

                    return .none
                }

            case let .updatedValidity(isValid):
                state.isValid = isValid
                return .none

            default:
                return .none
            }
        }
    )
}
