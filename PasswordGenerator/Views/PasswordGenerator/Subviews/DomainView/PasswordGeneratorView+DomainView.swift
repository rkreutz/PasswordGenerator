import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct DomainView: View {

        let store: Store<State, Action>

        var body: some View {

            WithViewStore(store) { viewStore in

                TextField(
                    Strings.PasswordGeneratorView.username,
                    text: viewStore.binding(get: \.username, send: Action.updatedUsername)
                )
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

                SeparatorView()

                TextField(
                    Strings.PasswordGeneratorView.domain,
                    text: viewStore.binding(get: \.domain, send: Action.updatedDomain)
                )
                .autocapitalization(.none)
                .keyboardType(.URL)

                SeparatorView()

                CounterView(store: store.scope(state: \.seed, action: Action.updatedSeed))
            }
        }
    }
}
