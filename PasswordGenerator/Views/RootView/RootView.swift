import SwiftUI

struct RootView: View {

    @ObservedObject var appState: AppState

    var body: some View {

        switch appState.state {

        case .masterPasswordSet:
            return NavigationView {

                PasswordGeneratorView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .asAny()

        case .mustProvideMasterPassword:
            return MasterPasswordView().asAny()
        }
    }
}
