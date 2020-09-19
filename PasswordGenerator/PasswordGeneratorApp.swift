import SwiftUI

@main
struct PasswordGeneratorApp: App {

    @StateObject var appState = AppState(from: MasterPasswordValidatorEnvironmentKey.defaultValue)

    var body: some Scene {

        WindowGroup(Strings.App.windowTitle) {

            Group {

                if case .masterPasswordSet = appState.state {

                    NavigationView { PasswordGeneratorView() }
                        .navigationViewStyle(StackNavigationViewStyle())
                } else {

                    MasterPasswordView()
                }
            }
            .handlingErrors(using: AlertErrorHandler())
            .use(appState: appState)
        }
    }
}
