import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct DomainView: View {

        struct ViewState: Equatable {
            @BindingState var username: String
            @BindingState var domain: String
        }

        enum ViewAction: BindableAction {
            case binding(BindingAction<ViewState>)

            var domainAction: PasswordGenerator.Domain.Action {
                switch self {
                case .binding(let action):
                    return .binding(action.pullback(\.view))
                }
            }
        }

        let store: StoreOf<PasswordGenerator.Domain>
        @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

        init(store: StoreOf<PasswordGenerator.Domain>) {
            self.store = store
            self.viewStore = ViewStore(
                store,
                observe: \.view,
                send: \.domainAction
            )
        }

        var body: some View {
            TextField(
                Strings.PasswordGeneratorView.username,
                text: viewStore.binding(\.$username)
            )
            .autocapitalization(.none)
            .keyboardType(.emailAddress)

            SeparatorView()

            TextField(
                Strings.PasswordGeneratorView.domain,
                text: viewStore.binding(\.$domain)
            )
            .autocapitalization(.none)
            .keyboardType(.URL)

            SeparatorView()

            CounterView(
                title: Strings.PasswordGeneratorView.seed,
                store: store.scope(state: \.seed, action: PasswordGenerator.Domain.Action.seed)
            )
        }
    }
}

private extension PasswordGenerator.Domain.State {
    var view: PasswordGeneratorView.DomainView.ViewState {
        get { .init(username: username, domain: domain) }
        set {
            username = newValue.username
            domain = newValue.domain
        }
    }
}
