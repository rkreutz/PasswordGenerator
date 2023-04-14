import ComposableArchitecture
import SwiftUI

struct DesktopScene: Scene {

    typealias AppState = PasswordGeneratorApp.AppState
    typealias AppAction = PasswordGeneratorApp.AppAction

    let store: StoreOf<Application>

    @ScaledMetric private var defaultWidth: CGFloat = 800
    @ScaledMetric private var defaultHeight: CGFloat = 500

    var body: some Scene {
        WindowGroup(Strings.App.windowTitle) {
            WithViewStore(store, observe: \.app, send: \AppAction.domainAction) { viewStore in
                if viewStore.isMasterPasswordSet {
                    TabBar(selection: viewStore.binding(\.$tab), store: store)
                } else {
                    MasterPasswordView(store: store.scope(state: \.masterPassword, action: Application.Action.masterPassword))
                }
            }
            .accentColor(.accentColor)
            .handlingErrors(using: AlertErrorHandler())
        }
        .defaultSizeIfApplicable(width: defaultWidth, height: defaultHeight)
    }
}

private extension Application.State {
    var app: PasswordGeneratorApp.AppState {
        get { .init(isMasterPasswordSet: isMasterPasswordSet, tab: tab) }
        set { tab = newValue.tab }
    }
}
