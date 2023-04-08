import SwiftUI
import ComposableArchitecture

@main
struct PasswordGeneratorApp: App {

    enum Constants {

        static let generatorIconName = "key.fill"
        static let configurationIconName = "gearshape.fill"
    }

    @ScaledMetric private var maxWidth: CGFloat = 450

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
                        .frame(maxWidth: maxWidth)

                case true:
                    TabView {
                        PasswordGeneratorView(
                            store: store.scope(
                                state: \.passwordGenerator,
                                action: Application.Action.passwordGenerator
                            )
                        )
                        .frame(maxWidth: maxWidth)
                        .tabItem { Label(Strings.PasswordGeneratorApp.generatorTabTitle, systemImage: Constants.generatorIconName) }

                        AppConfigurationView(
                            store: store.scope(
                                state: \.configuration,
                                action: Application.Action.configuration
                            )
                        )
                        .frame(maxWidth: maxWidth)
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
