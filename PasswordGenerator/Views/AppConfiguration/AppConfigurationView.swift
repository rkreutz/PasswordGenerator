//swiftlint:disable closure_body_length
import SwiftUI
import PasswordGeneratorKit
import ComposableArchitecture

struct AppConfigurationView: View {

    struct ViewState: Equatable {
        var derivationAlgorithm: AppConfiguration.KeyDerivationAlgorithm
        var error: Error?

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.derivationAlgorithm == rhs.derivationAlgorithm
            && lhs.error?.localizedDescription == rhs.error?.localizedDescription
        }
    }

    enum ViewAction {
        case didTapResetMasterPassword
        case didScrollView
        case didReceiveError(Error?)

        var domainAction: AppConfiguration.Action {
            switch self {
            case .didTapResetMasterPassword:
                return .didTapResetMasterPassword

            case .didScrollView:
                return .didScrollView

            case .didReceiveError(let error):
                return .didReceiveError(error)
            }
        }
    }

    let store: StoreOf<AppConfiguration>
    @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

    init(store: StoreOf<AppConfiguration>) {
        self.store = store
        self.viewStore = ViewStore(
            store,
            observe: \.view,
            send: \.domainAction
        )
    }
    
    var body: some View {
        #if os(iOS)
        MobileView(store: store, viewStore: viewStore)
            .emittingError(viewStore.binding(get: \.error, send: ViewAction.didReceiveError))
        #elseif os(macOS)
        DesktopView(store: store, viewStore: viewStore)
            .emittingError(viewStore.binding(get: \.error, send: ViewAction.didReceiveError))
        #endif
    }
}

private extension AppConfiguration.State {
    var view: AppConfigurationView.ViewState {
        get { .init(derivationAlgorithm: derivationAlgorithm, error: error) }
        set { error = newValue.error }
    }
}
