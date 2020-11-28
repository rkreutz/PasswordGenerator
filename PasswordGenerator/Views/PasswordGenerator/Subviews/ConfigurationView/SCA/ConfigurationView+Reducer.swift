import Foundation
import ComposableArchitecture
import Combine

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
        Reducer { state, action, _ -> Effect<Action, Never> in

            switch action {

            case .updatePasswordType(.domainBased):
                state.passwordType = .domainBased
                state.isValid = state.domainState.isValid
                return Just(Action.didUpdate).eraseToEffect()

            case .updatePasswordType(.serviceBased):
                state.passwordType = .serviceBased
                state.isValid = state.serviceState.isValid
                return Just(Action.didUpdate).eraseToEffect()

            case .updateDomain(.didUpdate) where state.passwordType == .domainBased:
                state.isValid = state.domainState.isValid
                return Just(Action.didUpdate).eraseToEffect()

            case .updateService(.didUpdate) where state.passwordType == .serviceBased:
                state.isValid = state.serviceState.isValid
                return Just(Action.didUpdate).eraseToEffect()

            default:
                return .none
            }
        }
    )
}
