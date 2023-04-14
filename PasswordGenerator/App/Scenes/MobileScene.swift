import ComposableArchitecture
import SwiftUI

struct MobileScene: Scene {

    typealias AppState = PasswordGeneratorApp.AppState
    typealias AppAction = PasswordGeneratorApp.AppAction

    let store: StoreOf<Application>

    @ScaledMetric private var maxWidth: CGFloat = 490
    
    var body: some Scene {
        WindowGroup(Strings.App.windowTitle) {

            WithViewStore(store, observe: \.app, send: \AppAction.domainAction) { viewStore in

                switch UIDevice.current.userInterfaceIdiom {
                case .phone:
                    if viewStore.isMasterPasswordSet {
                        TabBar(selection: viewStore.binding(\.$tab), store: store)
                    } else {
                        MasterPasswordView(store: store.scope(state: \.masterPassword, action: Application.Action.masterPassword))
                    }

                case .pad, .mac:
                    GeometryReader { proxy in
                        if proxy.size.width > maxWidth {
                            TabBar(selection: viewStore.binding(\.$tab), store: store)
                                .sheet(isPresented: viewStore.binding(get: { !$0.isMasterPasswordSet }, send: { _ in .none })) {
                                    if #available(iOS 15.0, *) {
                                        MasterPasswordView(store: store.scope(state: \.masterPassword, action: Application.Action.masterPassword))
                                            .frame(width: maxWidth)
                                            .interactiveDismissDisabled()
                                    } else {
                                        MasterPasswordView(store: store.scope(state: \.masterPassword, action: Application.Action.masterPassword))
                                            .frame(width: maxWidth)
                                    }
                                }
                        } else {
                            if viewStore.isMasterPasswordSet {
                                TabBar(selection: viewStore.binding(\.$tab), store: store)
                            } else {
                                MasterPasswordView(store: store.scope(state: \.masterPassword, action: Application.Action.masterPassword))
                            }
                        }
                    }

                default:
                    Text(Strings.Error.notSupported)
                }
            }
            .accentColor(.accentColor)
            .background(
                Rectangle()
                    .foregroundColor(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
            )
            .handlingErrors(using: AlertErrorHandler())
        }
    }
}

private extension Application.State {
    var app: PasswordGeneratorApp.AppState {
        get { .init(isMasterPasswordSet: isMasterPasswordSet, tab: tab) }
        set { tab = newValue.tab }
    }
}
