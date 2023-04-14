import SwiftUI
import ComposableArchitecture

@main
struct PasswordGeneratorApp: App {

    struct AppState: Equatable {
        var isMasterPasswordSet: Bool
        @BindingState var tab: Application.State.Tab
    }

    enum AppAction: BindableAction {
        case none
        case binding(BindingAction<AppState>)

        var domainAction: Application.Action {
            switch self {
            case .none:
                return .none
            case .binding(let action):
                return .binding(action.pullback(\.app))
            }
        }
    }

    let store: StoreOf<Application> = withDependencies(
        { $0.context = .live},
        operation: { Store(initialState: Application.initialState(), reducer: Application()) }
    )

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
