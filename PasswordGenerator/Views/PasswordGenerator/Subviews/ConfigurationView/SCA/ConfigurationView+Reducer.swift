import Foundation
import ComposableArchitecture
import Combine

extension PasswordGeneratorView.ConfigurationView {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        PasswordGeneratorView.DomainView.sharedReducer
            .pullback(
                state: \.domainState,
                action: /Action.updatedDomain,
                environment: { _ in .init() }
            ),
        PasswordGeneratorView.ServiceView.sharedReducer
            .pullback(
                state: \.serviceState,
                action: /Action.updatedService,
                environment: { _ in .init() }
            ),
        Reducer { state, action, _ -> Effect<Action, Never> in

            switch action {

            case let .updatedPasswordType(passwordType):
                state.passwordType = passwordType
                return .none

            case .updatedDomain(.updatedValidity(true)) where !state.isValid && state.passwordType == .domainBased,
                 .updatedService(.updatedValidity(true)) where !state.isValid && state.passwordType == .serviceBased:
                return Just(Action.updatedValidity(true)).eraseToEffect()

            case .updatedDomain(.updatedValidity(false)) where state.isValid && state.passwordType == .domainBased,
                 .updatedService(.updatedValidity(false)) where state.isValid && state.passwordType == .serviceBased:
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
