import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct PasswordView: View {

        @ScaledMetric private var loaderSize: CGFloat = 44

        let store: Store<State, Action>

        var body: some View {

            WithViewStore(store) { viewStore in

                switch viewStore.flow {

                case .invalid, .readyToGenerate:
                    Button(Strings.PasswordGeneratorView.generatePassword, action: { viewStore.send(.generatePassword) })
                        .buttonStyle(MainButtonStyle())
                        .disabled(viewStore.flow == .invalid)

                case .loading:
                    ProgressView()
                        .frame(height: loaderSize)
                        .progressViewStyle(LoaderStyle())

                case .generated:
                    CopyableContentView(store: store.scope(state: \.copyableState, action: Action.copyableContentUpdated))
                        .expandedInParent()
                        .asCard()
                }
            }
        }
    }
}
