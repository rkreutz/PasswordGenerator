import SwiftUI
import ComposableArchitecture

@main
struct PasswordGeneratorApp: App {

    enum Constants {

        static let generatorIconName = "key.fill"
        static let configurationIconName = "gearshape.fill"
    }

    let store: StoreOf<Application> = withDependencies(
        { $0.context = .live},
        operation: { Store(initialState: Application.initialState(), reducer: Application()) }
    )

    var body: some Scene {

        WindowGroup(Strings.App.windowTitle) {

            WithViewStore(store, observe: \.isMasterPasswordSet) { viewStore in

                switch viewStore.state {

                case false:
                    MasterPasswordView(store: store.scope(state: \.masterPassword, action: Application.Action.masterPassword))

                case true:
                    TabView {
                        PasswordGeneratorView(
                            store: store.scope(
                                state: \.passwordGenerator,
                                action: Application.Action.passwordGenerator
                            )
                        )
                        .tabItem { Label(Strings.PasswordGeneratorApp.generatorTabTitle, systemImage: Constants.generatorIconName) }

                        AppConfigurationView(
                            store: store.scope(
                                state: \.configuration,
                                action: Application.Action.configuration
                            )
                        )
                        .tabItem { Label(Strings.PasswordGeneratorApp.configurationTabTitle, systemImage: Constants.configurationIconName) }
                    }
                }
            }
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
