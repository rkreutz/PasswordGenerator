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

    @ScaledMetric private var spacing: CGFloat = 16

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
        Form {
            Section {
                Button(Strings.AppConfigurationView.clearMasterPasswordTitle) {
                    viewStore.send(.didTapResetMasterPassword)
                }
                .foregroundColor(.red)
            }

            Section(
                content: {
                    GeneratorPicker(store: store)
                    GeneratorTextField(
                        title: Strings.AppConfigurationView.iterationsTitle,
                        store: store,
                        \.$iterations
                    )
                    switch viewStore.derivationAlgorithm {
                    case .argon:
                        GeneratorTextField(
                            title: Strings.AppConfigurationView.memoryTitle,
                            store: store,
                            \.$memory
                        )
                        GeneratorTextField(
                            title: Strings.AppConfigurationView.threadsTitle,
                            store: store,
                            \.$threads
                        )
                    case .pbkdf:
                        EmptyView()
                    }
                    EntropySizePicker(store: store)
                },
                header: { Text(Strings.AppConfigurationView.entropyConfigurationSectionTitle) },
                footer: { Text(Strings.AppConfigurationView.entropyConfigurationSectionDescription) }
            )
        }
        .simultaneousGesture(DragGesture().onChanged { _ in viewStore.send(.didScrollView) })
        .emittingError(viewStore.binding(get: \.error, send: ViewAction.didReceiveError))
    }
}

private extension AppConfiguration.State {
    var view: AppConfigurationView.ViewState {
        get { .init(derivationAlgorithm: derivationAlgorithm, error: error) }
        set { error = newValue.error }
    }
}
