import SwiftUI

@main
struct PasswordGeneratorApp: App {

    @StateObject var appState = AppState(from: MasterPasswordValidatorEnvironmentKey.defaultValue)

    var body: some Scene {

        WindowGroup(Strings.App.windowTitle) {

            Group {

                switch appState.state {

                case .mustProvideMasterPassword:
                    MasterPasswordView()

                case .masterPasswordSet:
                    NavigationView { PasswordGeneratorView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                }
            }
            .handlingErrors(using: AlertErrorHandler())
            .use(appState: appState)
        }
    }
}
