import Foundation
import ComposableArchitecture
import AuthenticationServices

extension CredentialProviderViewController {

    var reducer: PasswordGeneratorView.Reducer {

        PasswordGeneratorView.Reducer.combine(
            PasswordGeneratorView.sharedReducer,
            PasswordGeneratorView.Reducer { [extensionContext] state, action, _ -> Effect<PasswordGeneratorView.Action, Never> in

                switch (action, state.configurationState.passwordType) {

                case let (.updatedPasswordState(.updateFlow(.generated(password))), .domainBased):
                    extensionContext.completeRequest(
                        withSelectedCredential: ASPasswordCredential(
                            user: state.configurationState.domainState.username,
                            password: password
                        ),
                        completionHandler: nil
                    )
                    return .none

                case let (.updatedPasswordState(.updateFlow(.generated(password))), .serviceBased):
                    extensionContext.completeRequest(
                        withSelectedCredential: ASPasswordCredential(
                            user: state.configurationState.serviceState.service,
                            password: password
                        ),
                        completionHandler: nil
                    )
                    return .none

                default:
                    return .none
                }
            }
        )
    }
}
