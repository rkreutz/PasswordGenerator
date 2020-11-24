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
                    NavigationView { PasswordGeneratorView() }
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
