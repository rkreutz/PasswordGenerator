import ComposableArchitecture
import SwiftUI

extension AppConfigurationView {
    struct EntropySizePicker: View {

        typealias ViewState = BindingState<UInt>

        enum ViewAction: BindableAction {
            case binding(BindingAction<ViewState>)

            var domainAction: AppConfiguration.Action {
                switch self {
                case .binding(let action):
                    return .binding(action.pullback(\.$entropySize))
                }
            }
        }

        @ScaledMetric private var spacing: CGFloat = 16

        @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

        init(store: StoreOf<AppConfiguration>) {
            self.viewStore = ViewStore(
                store,
                observe: \.$entropySize,
                send: \.domainAction
            )
        }

        var body: some View {
            HStack(spacing: spacing) {
                Text(Strings.AppConfigurationView.entropySizeTitle)

                Spacer()

                Picker("", selection: viewStore.binding(\.self)) {
                    Text("24").tag(24 as UInt)
                    Text("32").tag(32 as UInt)
                    Text("40").tag(40 as UInt)
                    Text("48").tag(48 as UInt)
                    Text("56").tag(56 as UInt)
                    Text("64").tag(64 as UInt)
                }
                .buttonStyle(.bordered)
                .pickerStyle(.menu)
            }
        }
    }
}
