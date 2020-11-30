import Foundation
import ComposableArchitecture
import CasePaths

extension PasswordGeneratorView.ConfigurationView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        PasswordGeneratorView.DomainView.sharedReducer
            .pullback(
                state: \.domainState,
                action: /Action.updateDomain,
                environment: { _ in .init() }
            ),
        PasswordGeneratorView.ServiceView.sharedReducer
            .pullback(
                state: \.serviceState,
                action: /Action.updateService,
                environment: { _ in .init() }
            ),
        Reducer(forAction: /Action.updatePasswordType) { state, passwordType, _ -> Effect<Action, Never> in

            state.passwordType = passwordType
            switch passwordType {

            case .domainBased:
                state.isValid = state.domainState.isValid

            case .serviceBased:
                state.isValid = state.serviceState.isValid
            }

            return Effect(value: Action.didUpdate)
        },
        Reducer(forActions: didUpdateDomain, didUpdateService) { state, _ -> Effect<Action, Never> in

            switch state.passwordType {

            case .domainBased:
                state.isValid = state.domainState.isValid

            case .serviceBased:
                state.isValid = state.serviceState.isValid
            }

            return Effect(value: Action.didUpdate)
        }
    )

    private static let didUpdateDomain = /Action.updateDomain .. /PasswordGeneratorView.DomainView.Action.didUpdate
    private static let didUpdateService = /Action.updateService .. /PasswordGeneratorView.ServiceView.Action.didUpdate
}
