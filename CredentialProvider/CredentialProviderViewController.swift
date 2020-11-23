import AuthenticationServices
import SwiftUI
import Combine
import os.log

class CredentialProviderViewController: ASCredentialProviderViewController {

    private var cancellableStore: Set<AnyCancellable> = []
    private var viewState = StateReference(state: PasswordGeneratorView.ViewState())

    @IBSegueAction
    private func addSwiftUI(_ coder: NSCoder) -> UIViewController? {

        UIHostingController(
            coder: coder,
            rootView: PasswordGeneratorView(viewStateReference: viewState)
                .frame(maxWidth: 450)
                .accentColor(.accentColor)
                .background(
                    Rectangle()
                        .foregroundColor(.systemBackground)
                        .edgesIgnoringSafeArea(.all)
                )
        )
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        viewState.$state
            .compactMap { state -> String? in

                guard case let .generated(password) = state.passwordState else { return nil }
                return password
            }
            .sink { [extensionContext, viewState] password in

                extensionContext.completeRequest(
                    withSelectedCredential: ASPasswordCredential(
                        user: viewState.state.configurationState.username,
                        password: password
                    ),
                    completionHandler: nil
                )
            }
            .store(in: &cancellableStore)
    }

    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {

        let host = serviceIdentifiers
            .first { $0.type == .URL }
            .flatMap { URL(string: $0.identifier)?.host }

        viewState.state.configurationState.domain = host ?? ""
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
