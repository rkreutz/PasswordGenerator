import AuthenticationServices
import SwiftUI
import Combine
import ComposableArchitecture
import os.log

class CredentialProviderViewController: ASCredentialProviderViewController {

    private var cancellableStore: Set<AnyCancellable> = []
    private var viewState = StateReference(state: PasswordGeneratorView.ViewState())

    @IBSegueAction
    private func addSwiftUI(_ coder: NSCoder) -> UIViewController? {

        UIHostingController(
            coder: coder,
            rootView: PasswordGeneratorView(
                store: Store<PasswordGeneratorView.State, PasswordGeneratorView.Action>.init(
                    initialState: .init(
                        configurationState: .init(
                            passwordType: .domainBased,
                            domainState: .init(
                                username: "",
                                domain: "",
                                seed: .init(
                                    title: Strings.PasswordGeneratorView.seed.formatted(),
                                    count: 1,
                                    bounds: 1 ... 999
                                ),
                                isValid: false
                            ),
                            serviceState: .init(
                                service: "",
                                isValid: false
                            ),
                            isValid: false
                        ),
                        lengthState: .init(
                            lengthState: .init(
                                title: Strings.PasswordGeneratorView.passwordLength.formatted(),
                                count: 8,
                                bounds: 4 ... 32
                            )
                        ),
                        charactersState: .init(
                            digitsState: .init(
                                toggleTitle: Strings.PasswordGeneratorView.decimalCharacters.formatted(),
                                isToggled: true,
                                counterState: .init(
                                    title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                    count: 1,
                                    bounds: 1 ... 8
                                )
                            ),
                            symbolsState: .init(
                                toggleTitle: Strings.PasswordGeneratorView.symbolsCharacters.formatted(),
                                isToggled: false,
                                counterState: .init(
                                    title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                    count: 0,
                                    bounds: 1 ... 8
                                )
                            ),
                            lowercaseState: .init(
                                toggleTitle: Strings.PasswordGeneratorView.lowercasedCharacters.formatted(),
                                isToggled: true,
                                counterState: .init(
                                    title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                    count: 1,
                                    bounds: 1 ... 8
                                )
                            ),
                            uppercaseState: .init(
                                toggleTitle: Strings.PasswordGeneratorView.uppercasedCharacters.formatted(),
                                isToggled: true,
                                counterState: .init(
                                    title: Strings.PasswordGeneratorView.numberOfCharacters.formatted(),
                                    count: 1,
                                    bounds: 1 ... 8
                                )
                            ),
                            isValid: true
                        ),
                        passwordState: .init(
                            flow: .invalid,
                            copyableState: .init(content: "")
                        )
                    ),
                    reducer: PasswordGeneratorView.sharedReducer,
                    environment: PasswordGeneratorView.Environment.live()
                )
            )
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
