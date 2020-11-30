import Foundation
import ComposableArchitecture
import AuthenticationServices
import CasePaths

extension CredentialProviderViewController {

    var reducer: PasswordGeneratorView.Reducer {

        PasswordGeneratorView.Reducer.combine(
            PasswordGeneratorView.sharedReducer,
            PasswordGeneratorView.Reducer(
                forAction: /PasswordGeneratorView.Action.updatedPasswordState
                    .. /PasswordGeneratorView.PasswordView.Action.updateFlow
                    .. /PasswordGeneratorView.PasswordView.Flow.generated
            ) { [extensionContext] state, password, _ -> Effect<PasswordGeneratorView.Action, Never> in

                switch state.configurationState.passwordType {

                case .domainBased:
                    extensionContext.completeRequest(
                        withSelectedCredential: ASPasswordCredential(
                            user: state.configurationState.domainState.username,
                            password: password
                        ),
                        completionHandler: nil
                    )

                case .serviceBased:
                    extensionContext.completeRequest(
                        withSelectedCredential: ASPasswordCredential(
                            user: state.configurationState.serviceState.service,
                            password: password
                        ),
                        completionHandler: nil
                    )
                }

                return .none
            }
        )
    }
}
