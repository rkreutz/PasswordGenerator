import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct ServiceView: View {

        let store: Store<State, Action>

        var body: some View {

            WithViewStore(store) { viewStore in

                TextField(
                    Strings.PasswordGeneratorView.service,
                    text: viewStore.binding(get: \.service, send: Action.updatedService)
                )
                .autocapitalization(.sentences)
                .keyboardType(.default)
            }
        }
    }
}
