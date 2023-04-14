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
            #if os(iOS)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            #endif

            #if os(iOS)
            SeparatorView()
            #endif

            TextField(
                Strings.PasswordGeneratorView.domain,
                text: viewStore.binding(\.$domain)
            )
            #if os(iOS)
            .autocapitalization(.none)
            .keyboardType(.URL)
            #endif

            #if os(iOS)
            SeparatorView()
            #endif

            #if os(iOS)
            CounterView(
                title: Strings.PasswordGeneratorView.seed,
                store: store.scope(state: \.seed, action: PasswordGenerator.Domain.Action.seed)
            )
            #elseif os(macOS)
            HStack {
                CounterView(
                    title: Strings.PasswordGeneratorView.seed,
                    store: store.scope(state: \.seed, action: PasswordGenerator.Domain.Action.seed)
                )

                Spacer()
            }
            #endif
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
