import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct ServiceView: View {

        typealias ViewState = BindingState<String>

        enum ViewAction: BindableAction {
            case binding(BindingAction<ViewState>)

            var domainAction: PasswordGenerator.Service.Action {
                switch self {
                case .binding(let action):
                    return .binding(action.pullback(\.$service))
                }
            }
        }

        @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

        init(store: StoreOf<PasswordGenerator.Service>) {
            self.viewStore = ViewStore(
                store,
                observe: \.$service,
                send: \.domainAction
            )
        }

        var body: some View {
            TextField(
                Strings.PasswordGeneratorView.service,
                text: viewStore.binding(\.self)
            )
            .autocapitalization(.sentences)
            .keyboardType(.default)
        }
    }
}
