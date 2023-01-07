import Foundation
import UIKit
import ComposableArchitecture
import PasswordGeneratorKit
import CasePaths

extension PasswordGeneratorApp {

    typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    static let sharedReducer = Reducer.combine(
        MasterPasswordView.sharedReducer
            .pullback(
                state: \.masterPasswordState,
                action: /Action.updatedMasterPassword,
                environment: MasterPasswordView.Environment.init(from:)
            ),
        PasswordGeneratorView.sharedReducer
            .pullback(
                state: \.passwordGeneratorState,
                action: /Action.updatedPasswordGenerator,
                environment: PasswordGeneratorView.Environment.init(from:)
            ),
        AppConfigurationView.sharedReducer
            .pullback(
                state: \.configurationState,
                action: /Action.updatedConfiguration,
                environment: AppConfigurationView.Environment.init(from:)
            ),
        Reducer(forAction: .didSaveMasterPassword) { state, _ in

            state.isMasterPasswordSet = true
            state.masterPasswordState.masterPassword = ""
            return .none
        },
        Reducer(forAction: .loggedOutAction) { state, _ in

            state.isMasterPasswordSet = false
            return Effect(value: Action.updatedPasswordGenerator(.didLogout))
        },
        Reducer(forAction: .didUpdateEntropyConfiguration) { state, entropyConfiguration, _ in

            let (entropyGenerator, entropySize) = entropyConfiguration
            state.passwordGeneratorState.entropyGenerator = entropyGenerator
            state.passwordGeneratorState.entropySize = entropySize
            return Effect(value: Action.updatedPasswordGenerator(.updatedConfigurationState(.didUpdate)))
        },
        Reducer(forAction: /PasswordGeneratorApp.Action.updatedConfiguration(.shouldDismissKeyboard)) { _, _ in
            #if APP
            UIApplication.shared.windows.forEach { $0.endEditing(true) }
            #endif
            return .none
        }
    )
}

private extension CasePath where Root == PasswordGeneratorApp.Action, Value == Void {

    static let didSaveMasterPassword = /PasswordGeneratorApp.Action.updatedMasterPassword .. /MasterPasswordView.Action.masterPasswordSaved
    static let loggedOutAction = /PasswordGeneratorApp.Action.updatedConfiguration .. /AppConfigurationView.Action.didResetMasterPassword
}

private extension CasePath where Root == PasswordGeneratorApp.Action, Value == (PasswordGenerator.EntropyGenerator, UInt) {

    static let didUpdateEntropyConfiguration = /PasswordGeneratorApp.Action.updatedConfiguration .. /AppConfigurationView.Action.entropyConfigurationUpdated
}
