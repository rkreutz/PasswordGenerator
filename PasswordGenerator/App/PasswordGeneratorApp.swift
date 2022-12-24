import SwiftUI
import ComposableArchitecture

@main
struct PasswordGeneratorApp: App {

    enum Constants {

        static let generatorIconName = "key.fill"
        static let configurationIconName = "gearshape.fill"
    }

    @ScaledMetric private var maxWidth: CGFloat = 450

    let store: Store<State, Action> = { (environment: Environment) in
        Store(
            initialState: PasswordGeneratorApp.initialState(environment: environment),
            reducer: PasswordGeneratorApp.sharedReducer,
            environment: environment
        )
    }(Environment.live())

    var body: some Scene {

        WindowGroup(Strings.App.windowTitle) {

            WithViewStore(store) { viewStore in

                switch viewStore.isMasterPasswordSet {

                case false:
                    MasterPasswordView(store: store.scope(state: \.masterPasswordState, action: Action.updatedMasterPassword))

                case true:
                    TabView {
                        PasswordGeneratorView(
                            store: store.scope(
                                state: \.passwordGeneratorState,
                                action: Action.updatedPasswordGenerator
                            )
                        )
                        .tabItem { Label(Strings.PasswordGeneratorApp.generatorTabTitle, systemImage: Constants.generatorIconName) }

                        AppConfigurationView(
                            store: store.scope(
                                state: \.configurationState,
                                action: Action.updatedConfiguration
                            )
                        )
                        .tabItem { Label(Strings.PasswordGeneratorApp.configurationTabTitle, systemImage: Constants.configurationIconName) }
                    }
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
