import SwiftUI
import ComposableArchitecture

@main
struct PasswordGeneratorApp: App {

    @ScaledMetric private var maxWidth: CGFloat = 450

    let store: Store<State, Action> = .init(
        initialState: PasswordGeneratorApp.initialState,
        reducer: PasswordGeneratorApp.sharedReducer,
        environment: .live()
    )

    var body: some Scene {

        WindowGroup(Strings.App.windowTitle) {

            WithViewStore(store) { viewStore in

                switch viewStore.isMasterPasswordSet {

                case false:
                    MasterPasswordView(store: store.scope(state: \.masterPasswordState, action: Action.updatedMasterPassword))

                case true:
                    NavigationView {

                        PasswordGeneratorView(store: store.scope(state: \.passwordGeneratorState, action: Action.updatedPasswordGenerator))
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
        }
    }
}
