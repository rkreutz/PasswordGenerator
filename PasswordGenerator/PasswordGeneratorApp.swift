import SwiftUI

@main
struct PasswordGeneratorApp: App {

    @StateObject var appState = AppState(from: MasterPasswordValidatorEnvironmentKey.defaultValue)
    @ScaledMetric private var maxWidth: CGFloat = 450

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
