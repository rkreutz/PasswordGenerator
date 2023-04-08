import ComposableArchitecture
import UIKit

struct Application: Reducer {
    struct State: Equatable {
        var isMasterPasswordSet: Bool
        var masterPassword: MasterPassword.State
        var passwordGenerator: PasswordGenerator.State
        var configuration: AppConfiguration.State
    }

    enum Action {
        case masterPassword(MasterPassword.Action)
        case passwordGenerator(PasswordGenerator.Action)
        case configuration(AppConfiguration.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.masterPassword, action: /Action.masterPassword) { MasterPassword() }
        Scope(state: \.passwordGenerator, action: /Action.passwordGenerator) { PasswordGenerator() }
        Scope(state: \.configuration, action: /Action.configuration) { AppConfiguration() }
        Reduce { state, action in
            switch action {
            case .masterPassword(.didSaveMasterPassword):
                state.isMasterPasswordSet = true
                state.masterPassword.masterPassword = ""
                return .none

            case .configuration(.didResetMasterPassword):
                state.isMasterPasswordSet = false
                return .send(Action.passwordGenerator(.didResetMasterPassword))

            case .configuration(.binding(\.$entropySize)):
                state.passwordGenerator.entropySize = state.configuration.entropySize
                return .none

            case .configuration(.binding):
                state.passwordGenerator.entropyGenerator = state.configuration.entropyGenerator
                return .none

            case .configuration(.didScrollView):
                #if APP
                UIApplication.shared.windows.forEach { $0.endEditing(true) }
                #endif
                return .none

            default:
                return .none
            }
        }
    }
}
