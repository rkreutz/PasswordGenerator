import ComposableArchitecture
import SwiftUI

#if os(iOS)
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
        @State private var isFocused: Bool = false

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

                if #available(iOS 15, *) {
                    TextFieldWithFocus(
                        text: viewStore.binding(\.self).map(to: String.init, from: UInt.init(_:)),
                        isFocused: $isFocused
                    )
                } else {
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
}

private extension AppConfigurationView.GeneratorTextField {
    @available(iOS 15, *)
    struct TextFieldWithFocus: View {

        @Binding var text: String
        @Binding var isFocused: Bool

        @FocusState private var focusState: Bool

        var body: some View {
            TextField(
                "",
                text: $text
            )
            .focused($focusState)
            .fixedSize()
            .keyboardType(.numberPad)
            .bind($isFocused, to: $focusState)
        }
    }
}
#elseif os(macOS)
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

        private let title: LocalizedStringKey
        @ObservedObject private var viewStore: ViewStore<ViewState, ViewAction>
        @ScaledMetric private var minWidth: CGFloat = 86

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
            HStack {
                Text(title)
                    .frame(minWidth: minWidth)

                Spacer()

                TextField("", text: viewStore.binding(\.self).map(to: String.init, from: UInt.init(_:)))
            }
        }
    }
}
#endif
