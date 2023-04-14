//swiftlint:disable closure_body_length
import SwiftUI
import ComposableArchitecture

struct MasterPasswordView: View {

    typealias ViewState = MasterPassword.State
    typealias ViewAction = MasterPassword.Action

    @ScaledMetric private var maxWidth: CGFloat = 490

    @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

    init(store: StoreOf<MasterPassword>) {
        self.viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        #if os(iOS)
        GeometryReader { proxy in
            if proxy.size.width > maxWidth {
                LargeView(
                    screenWidth: proxy.size.width,
                    isValid: viewStore.isValid,
                    masterPassword: viewStore.binding(\.$masterPassword),
                    saveAction: { viewStore.send(.didTapSave) }
                )
            } else {
                CompactView(
                    isValid: viewStore.isValid,
                    masterPassword: viewStore.binding(\.$masterPassword),
                    saveAction: { viewStore.send(.didTapSave) }
                )
            }
        }
        .emittingError(viewStore.binding(get: \.error, send: MasterPassword.Action.didReceiveError))
        #elseif os(macOS)
        DesktopView(
            isValid: viewStore.isValid,
            masterPassword: viewStore.binding(\.$masterPassword),
            saveAction: { viewStore.send(.didTapSave) }
        )
        .emittingError(viewStore.binding(get: \.error, send: MasterPassword.Action.didReceiveError))
        #endif
    }
}
