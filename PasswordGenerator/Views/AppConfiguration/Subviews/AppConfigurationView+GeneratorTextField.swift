import ComposableArchitecture
import SwiftUI

extension AppConfigurationView {
    struct GeneratorTextField: View {

        typealias ViewState = BindingState<UInt>

        enum ViewAction: BindableAction {
            case binding(BindingAction<ViewState>)

            func domainAction(_ keyPath: WritableKeyPath<AppConfiguration.State, BindingState<UInt>>) -> AppConfiguration.Action {
                switch self {
                case .binding(let action):
                    return .binding(action.pullback(keyPath))
                }
            }
        }

        @ScaledMetric private var spacing: CGFloat = 16

        private let title: LocalizedStringKey
        @ObservedObject private var viewStore: ViewStore<ViewState, ViewAction>

        init(
            title: LocalizedStringKey,
            store: StoreOf<AppConfiguration>,
            _ keyPath: WritableKeyPath<AppConfiguration.State, BindingState<UInt>>
        ) {
            self.title = title
            self.viewStore = ViewStore(
                store,
                observe: { $0[keyPath: keyPath] },
                send: { $0.domainAction(keyPath) }
            )
        }

        var body: some View {
            HStack(spacing: spacing) {
                Text(title)

                Spacer()

                TextField(
                    "",
                    text: viewStore.binding(\.self).map(to: String.init, from: UInt.init(_:))
                )
                .fixedSize()
                .keyboardType(.numberPad)
            }
        }
    }
}
