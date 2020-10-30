import AuthenticationServices
import SwiftUI
import Combine
import os.log

class CredentialProviderViewController: ASCredentialProviderViewController {

    private var cancellableStore: Set<AnyCancellable> = []

    private var hostingController: UIHostingController<PasswordGeneratorView>? {

        children.first(where: { $0 is UIHostingController<PasswordGeneratorView> }) as? UIHostingController<PasswordGeneratorView>
    }

    @IBSegueAction
    private func addSwiftUI(_ coder: NSCoder) -> UIViewController? {

        UIHostingController(
            coder: coder,
            rootView: PasswordGeneratorView(viewState: .init())
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

//        viewModel.$passwordState
//            .compactMap { state -> String? in
//
//                guard case let .generated(password) = state else { return nil }
//                return password
//            }
//            .sink { [extensionContext, viewModel] password in
//
//                extensionContext.completeRequest(
//                    withSelectedCredential: ASPasswordCredential(
//                        user: viewModel.username,
//                        password: password
//                    ),
//                    completionHandler: nil
//                )
//            }
//            .store(in: &cancellableStore)
    }

    override func prepareCredentialList(for serviceIdentifiers: [ASCredentialServiceIdentifier]) {

        let host = serviceIdentifiers
            .first { $0.type == .URL }
            .flatMap { URL(string: $0.identifier)?.host }

        hostingController?.rootView = PasswordGeneratorView(viewState: PasswordGeneratorView.ViewState(configurationState: .init(passwordType: .domainBased, domain: host ?? "")))
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
