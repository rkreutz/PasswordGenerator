import SwiftUI
import ComposableArchitecture

@main
struct PasswordGeneratorApp: App {

    @StateObject var appState = AppState(from: MasterPasswordValidatorEnvironmentKey.defaultValue)
    @ScaledMetric private var maxWidth: CGFloat = 450

    var body: some Scene {

        WindowGroup(Strings.App.windowTitle) {

            Group {

                switch appState.state {

                case .mustProvideMasterPassword:
                    MasterPasswordView(
                        store: .init(
                            initialState: MasterPasswordView.State(),
                            reducer: Reducer.combine(
                                MasterPasswordView.sharedReducer,
                                Reducer { _, action, _ -> Effect<MasterPasswordView.Action, Never> in

                                    guard case .masterPasswordSaved = action else { return .none }
                                    appState.state = .masterPasswordSet
                                    return .none
                                }
                            ),
                            environment: MasterPasswordView.Environment(masterPasswordStorage: MasterPasswordKeychain())
                        )
                    )

                case .masterPasswordSet:
                    NavigationView {

                        PasswordGeneratorView(
                            store: .init(
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
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                }
            }
            .frame(maxWidth: maxWidth)
            .accentColor(.accentColor)
            .background(
                Rectangle()
                    .foregroundColor(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
            )
            .handlingErrors(using: AlertErrorHandler())
            .use(appState: appState)
        }
    }
}
