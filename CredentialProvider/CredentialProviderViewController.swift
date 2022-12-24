import AuthenticationServices
import SwiftUI
import Combine
import ComposableArchitecture

class CredentialProviderViewController: ASCredentialProviderViewController {

    private var cancellableStore: Set<AnyCancellable> = []

    lazy var store = Store<PasswordGeneratorView.State, PasswordGeneratorView.Action>(
        initialState: CredentialProviderViewController.initialState,
        reducer: reducer,
        environment: PasswordGeneratorView.Environment(from: PasswordGeneratorApp.Environment.live())
    )

    var viewStore: ViewStore<PasswordGeneratorView.State, PasswordGeneratorView.Action> {

        ViewStore(store)
    }

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

        viewStore.send(.updatedConfigurationState(.updateDomain(.updateDomain(host ?? ""))))
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
