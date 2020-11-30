import Foundation
import ComposableArchitecture
import CasePaths

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
        Reducer(forAction: didSaveMasterPassword) { state, _ in

            state.isMasterPasswordSet = true
            state.masterPasswordState.masterPassword = ""
            return .none
        },
        Reducer(forAction: loggedOutAction) { state, _ in

            state.isMasterPasswordSet = false
            return .none
        }
    )

    private static let didSaveMasterPassword = /Action.updatedMasterPassword .. /MasterPasswordView.Action.masterPasswordSaved
    private static let loggedOutAction = /Action.updatedPasswordGenerator .. /PasswordGeneratorView.Action.didLogout
}
