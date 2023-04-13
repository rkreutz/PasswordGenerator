import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct PasswordView: View {

        typealias ViewState = PasswordGenerator.Password.Flow

        enum ViewAction {
            case didTapGenerate
            case didTapCopy

            var domainAction: PasswordGenerator.Password.Action {
                switch self {
                case .didTapGenerate:
                    return .didTapGenerate
                case .didTapCopy:
                    return .copyableContent(.didTapCopyButton)
                }
            }
        }

        @ScaledMetric private var loaderSize: CGFloat = 44

        let store: StoreOf<PasswordGenerator.Password>
        @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

        init(store: StoreOf<PasswordGenerator.Password>) {
            self.store = store
            self.viewStore = ViewStore(
                store,
                observe: \.flow,
                send: \.domainAction
            )
        }

        var body: some View {
            Group {
                switch viewStore.state {

                case .invalid, .readyToGenerate:
                    Button(Strings.PasswordGeneratorView.generatePassword, action: { viewStore.send(.didTapGenerate) })
                        .buttonStyle(MainButtonStyle())
                        .disabled(viewStore.state == .invalid)

                case .loading:
                    ProgressView()
                        .frame(height: loaderSize)
                        .progressViewStyle(LoaderStyle())

                case .generated:
                    CopyableContentView(store: store.scope(state: \.copyableContent, action: PasswordGenerator.Password.Action.copyableContent))
                        .expandedInParent()
                        .asCard()
                        .onTapGesture { viewStore.send(.didTapCopy) }
                }
            }
        }
    }
}
