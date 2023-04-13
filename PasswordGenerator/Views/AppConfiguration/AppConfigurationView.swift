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

    @ScaledMetric private var maxWidth: CGFloat = 490
    @ScaledMetric private var spacing: CGFloat = 16
    @ScaledMetric private var headerSpacing: CGFloat = 4

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
        GeometryReader { proxy in
            ScrollView {
                FormSection {
                    Button(Strings.AppConfigurationView.clearMasterPasswordTitle, role: .destructive) {
                        viewStore.send(.didTapResetMasterPassword)
                    }
                    .buttonStyle(FormButtonStyle())
                }

                FormSection(
                    content: {
                        VStack(alignment: .leading) {
                            GeneratorTextField(
                                title: Strings.AppConfigurationView.iterationsTitle,
                                store: store,
                                \.$iterations
                            )
                            SeparatorView()
                            switch viewStore.derivationAlgorithm {
                            case .argon:
                                GeneratorTextField(
                                    title: Strings.AppConfigurationView.memoryTitle,
                                    store: store,
                                    \.$memory
                                )
                                SeparatorView()
                                GeneratorTextField(
                                    title: Strings.AppConfigurationView.threadsTitle,
                                    store: store,
                                    \.$threads
                                )
                                SeparatorView()
                            case .pbkdf:
                                EmptyView()
                            }
                            EntropySizePicker(store: store)
                        }
                        .padding()
                    },
                    header: {
                        VStack(alignment: .leading, spacing: headerSpacing) {
                            Text(Strings.AppConfigurationView.entropyConfigurationSectionTitle).padding(.horizontal)
                            GeneratorPicker(store: store)
                        }
                    },
                    footer: { Text(Strings.AppConfigurationView.entropyConfigurationSectionDescription).padding(.horizontal) }
                )
            }
            .padding([.horizontal], max((proxy.size.width - maxWidth) / 2, 0))
            .background(
                Rectangle()
                    .foregroundColor(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            )
            .scrollDismissesKeyboard(viewStore: viewStore)
        }
        .emittingError(viewStore.binding(get: \.error, send: ViewAction.didReceiveError))
    }
}

private extension View {
    func scrollDismissesKeyboard(viewStore: ViewStore<AppConfigurationView.ViewState, AppConfigurationView.ViewAction>) -> some View {
        if #available(iOS 16.0, *) {
            return scrollDismissesKeyboard(.interactively)
        } else {
            return simultaneousGesture(DragGesture().onChanged { _ in viewStore.send(.didScrollView) })
        }
    }
}

private extension AppConfiguration.State {
    var view: AppConfigurationView.ViewState {
        get { .init(derivationAlgorithm: derivationAlgorithm, error: error) }
        set { error = newValue.error }
    }
}
