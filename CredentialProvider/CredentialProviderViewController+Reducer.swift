import Foundation
import ComposableArchitecture
import AuthenticationServices

extension CredentialProviderViewController {

    @ReducerBuilder<PasswordGenerator.State, PasswordGenerator.Action>
    var reducer: some ReducerOf<PasswordGenerator> {
        PasswordGenerator()
        Reduce { [extensionContext] state, action in
            guard case let .password(.updateFlow(.generated(password))) = action else { return .none }
            switch state.configuration.passwordType {
            case .domainBased:
                extensionContext.completeRequest(
                    withSelectedCredential: ASPasswordCredential(
                        user: state.configuration.domain.username,
                        password: password
                    ),
                    completionHandler: nil
                )

            case .serviceBased:
                extensionContext.completeRequest(
                    withSelectedCredential: ASPasswordCredential(
                        user: state.configuration.service.service,
                        password: password
                    ),
                    completionHandler: nil
                )
            }
            return .none
        }
    }
}
