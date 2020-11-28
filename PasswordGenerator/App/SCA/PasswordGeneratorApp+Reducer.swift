import Foundation
import ComposableArchitecture

extension PasswordGeneratorApp {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        MasterPasswordView.sharedReducer
            .pullback(
                state: \.masterPasswordState,
                action: /Action.updatedMasterPassword,
                environment: MasterPasswordView.Environment.init
            ),
        PasswordGeneratorView.sharedReducer
            .pullback(
                state: \.passwordGeneratorState,
                action: /Action.updatedPasswordGenerator,
                environment: PasswordGeneratorView.Environment.init
            ),
        Reducer { state, action, _ -> Effect<Action, Never> in
            switch action {

            case .updatedMasterPassword(.masterPasswordSaved):
                state.isMasterPasswordSet = true
                state.masterPasswordState.masterPassword = ""

            case .updatedPasswordGenerator(.didLogout):
                state.isMasterPasswordSet = false

            default:
                break
            }

            return .none
        }
    )
}
