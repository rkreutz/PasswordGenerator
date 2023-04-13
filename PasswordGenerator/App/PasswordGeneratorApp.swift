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

                case .pad:
                    GeometryReader { proxy in
                        if proxy.size.width > maxWidth {
                            TabBar(selection: viewStore.binding(\.$tab), store: store)
                                .sheet(isPresented: viewStore.binding(get: { !$0.isMasterPasswordSet }, send: { _ in .none })) {
                                    MasterPasswordView(store: store.scope(state: \.masterPassword, action: Application.Action.masterPassword))
                                        .frame(width: maxWidth)
                                        .interactiveDismissDisabled()
                                }
                        } else {
                            if viewStore.isMasterPasswordSet {
                                TabBar(selection: viewStore.binding(\.$tab), store: store)
                            } else {
                                MasterPasswordView(store: store.scope(state: \.masterPassword, action: Application.Action.masterPassword))
                            }
                        }
                    }

                case .mac:
                    Text(Strings.Error.notSupported)
                    
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

private struct TabBar: View {

    enum Constants {
        static let generatorIconName = "key.fill"
        static let configurationIconName = "gearshape.fill"
    }

    let selection: Binding<Application.State.Tab>
    let store: StoreOf<Application>

    var body: some View {
        TabView(selection: selection) {
            PasswordGeneratorView(
                store: store.scope(
                    state: \.passwordGenerator,
                    action: Application.Action.passwordGenerator
                )
            )
            .tag(Application.State.Tab.generator)
            .tabItem { Label(Strings.PasswordGeneratorApp.generatorTabTitle, systemImage: Constants.generatorIconName) }

            AppConfigurationView(
                store: store.scope(
                    state: \.configuration,
                    action: Application.Action.configuration
                )
            )
            .tag(Application.State.Tab.config)
            .tabItem { Label(Strings.PasswordGeneratorApp.configurationTabTitle, systemImage: Constants.configurationIconName) }
        }
    }
}
