import ComposableArchitecture
import SwiftUI

extension AppConfigurationView {

    struct GeneratorPicker: View {

        typealias ViewState = BindingState<AppConfiguration.KeyDerivationAlgorithm>

        enum ViewAction: BindableAction {
            case binding(BindingAction<ViewState>)

            var domainAction: AppConfiguration.Action {
                switch self {
                case .binding(let action):
                    return .binding(action.pullback(\.$derivationAlgorithm))
                }
            }
        }

        @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

        init(store: StoreOf<AppConfiguration>) {
            self.viewStore = ViewStore(
                store,
                observe: \.$derivationAlgorithm,
                send: \.domainAction
            )
        }

        var body: some View {
            Picker(Strings.AppConfigurationView.keyDerivationTitle, selection: viewStore.binding(\.self)) {
                Text(Strings.AppConfigurationView.pbkdfTitle).tag(AppConfiguration.KeyDerivationAlgorithm.pbkdf)
                Text(Strings.AppConfigurationView.argonTitle).tag(AppConfiguration.KeyDerivationAlgorithm.argon)
            }
            #if os(iOS)
            .pickerStyle(.segmented)
            #endif
        }
    }
}
