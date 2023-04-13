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
        @FocusState private var isFocused: Bool

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
                ZStack {
                    HStack {
                        Text(title)

                        Spacer()
                    }

                    Button(
                        action: { isFocused = true },
                        label: { Text("").expandedInParent() }
                    )
                }

                TextField(
                    "",
                    text: viewStore.binding(\.self).map(to: String.init, from: UInt.init(_:))
                )
                .focused($isFocused)
                .fixedSize()
                .keyboardType(.numberPad)
            }
        }
    }
}
