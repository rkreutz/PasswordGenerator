import ComposableArchitecture
import SwiftUI

struct TabBar: View {

    enum Constants {
        static let generatorIconName = "key.fill"
        static let configurationIconName = "gearshape.fill"
    }

    let selection: Binding<Application.State.Tab>
    let store: StoreOf<Application>

    var body: some View {
        TabView(selection: selection) {
            PasswordGeneratorView(
                store: store.scope(
                    state: \.passwordGenerator,
                    action: Application.Action.passwordGenerator
                )
            )
            .tag(Application.State.Tab.generator)
            .tabItem { Label(Strings.PasswordGeneratorApp.generatorTabTitle, systemImage: Constants.generatorIconName) }

            AppConfigurationView(
                store: store.scope(
                    state: \.configuration,
                    action: Application.Action.configuration
                )
            )
            .tag(Application.State.Tab.config)
            .tabItem { Label(Strings.PasswordGeneratorApp.configurationTabTitle, systemImage: Constants.configurationIconName) }
        }
    }
}
