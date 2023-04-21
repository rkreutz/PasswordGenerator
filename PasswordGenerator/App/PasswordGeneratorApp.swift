import SwiftUI
import ComposableArchitecture

@main
struct PasswordGeneratorApp: App {

    struct AppState: Equatable {
        var isMasterPasswordSet: Bool
        @BindingState var tab: Application.State.Tab
    }

    enum AppAction: BindableAction {
        #if os(iOS)
        case none
        #endif
        case binding(BindingAction<AppState>)

        var domainAction: Application.Action {
            switch self {
            #if os(iOS)
            case .none:
                return .none
            #endif
            case .binding(let action):
                return .binding(action.pullback(\.app))
            }
        }
    }

    let store: StoreOf<Application>

    init() {
        store = withDependencies(
            { $0.context = .live},
            operation: { Store(initialState: Application.initialState(), reducer: Application(scheduler: DispatchQueue.main)) }
        )

        ViewStore(store.stateless).send(.didInitialiseApp)
    }

    var body: some Scene {
        #if os(iOS)
        MobileScene(store: store)
        #elseif os(macOS)
        DesktopScene(store: store)
        #endif
    }
}

private extension Application.State {
    var app: PasswordGeneratorApp.AppState {
        get { .init(isMasterPasswordSet: isMasterPasswordSet, tab: tab) }
        set { tab = newValue.tab }
    }
}
