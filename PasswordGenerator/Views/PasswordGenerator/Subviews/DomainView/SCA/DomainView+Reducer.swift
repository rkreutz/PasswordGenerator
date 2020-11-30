import Foundation
import ComposableArchitecture
import CasePaths

extension PasswordGeneratorView.DomainView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        CounterView.sharedReducer
            .pullback(
                state: \.seed,
                action: /Action.updateSeed,
                environment: { _ in CounterView.Environment() }
            ),
        Reducer(forAction: /Action.updateUsername) { state, username, _ -> Effect<Action, Never> in

            state.username = username
            state.isValid = isStateValid(state)
            return Effect(value: Action.didUpdate)
        },
        Reducer(forAction: /Action.updateDomain) { state, domain, _ -> Effect<Action, Never> in

            state.domain = domain
            state.isValid = isStateValid(state)
            return Effect(value: Action.didUpdate)
        },
        Reducer(
            forAction: didUpdateSeedCounter,
            handler: { _, _ in Effect(value: Action.didUpdate) }
        )
    )

    private static let didUpdateSeedCounter = /Action.updateSeed .. /CounterView.Action.didUpdate

    private static func isStateValid(_ state: State) -> Bool {

        let isValidDomain = state.domain.hasMatchingTypes(NSTextCheckingResult.CheckingType.link.rawValue)
        let isValidUsername = state.username.isNotEmpty
        return isValidDomain && isValidUsername
    }
}
