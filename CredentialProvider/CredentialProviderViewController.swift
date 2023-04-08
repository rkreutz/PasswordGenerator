import AuthenticationServices
import SwiftUI
import Combine
import ComposableArchitecture

class CredentialProviderViewController: ASCredentialProviderViewController {

    private var cancellableStore: Set<AnyCancellable> = []

    lazy var store = StoreOf<PasswordGenerator>(
        initialState: CredentialProviderViewController.initialState,
        reducer: reducer
    )

    @IBSegueAction
    private func addSwiftUI(_ coder: NSCoder) -> UIViewController? {
        UIHostingController(
            coder: coder,
            rootView: PasswordGeneratorView(store: store)
                .frame(maxWidth: 450)
                .accentColor(.accentColor)
                .background(
                    Rectangle()
                        .foregroundColor(.systemBackground)
                        .edgesIgnoringSafeArea(.all)
                )
        )
    }

    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {
        let host = serviceIdentifiers
            .first { $0.type == .URL }
            .flatMap { URL(string: $0.identifier)?.host }

        ViewStore(store.stateless).send(.configuration(.domain(.set(\.$domain, host ?? ""))))
    }

    @IBAction private func cancel(_ sender: AnyObject?) {
        extensionContext.cancelRequest(
            withError: NSError(
                domain: ASExtensionErrorDomain,
                code: ASExtensionError.userCanceled.rawValue
            )
        )
    }
}
