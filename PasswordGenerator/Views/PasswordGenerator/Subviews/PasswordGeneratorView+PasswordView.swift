import SwiftUI
import ComposableArchitecture

extension PasswordGeneratorView {

    struct PasswordView: View {

        let passwordState: PasswordState
        let action: () -> Void

        @ScaledMetric private var loaderSize: CGFloat = 44

        var body: some View {

            Group {

                switch passwordState {

                case .invalid, .readyToGenerate:
                    Button(Strings.PasswordGeneratorView.generatePassword, action: action)
                        .buttonStyle(MainButtonStyle())
                        .disabled(passwordState == .invalid)

                case .loading:
                    ProgressView()
                        .frame(height: loaderSize)
                        .progressViewStyle(LoaderStyle())

                case let .generated(password):
                    CopyableContentView(store: Store(
                            initialState: CopyableContentView.State(content: password),
                            reducer: CopyableContentView.sharedReducer,
                            environment: CopyableContentView.Environment.live()
                        )
                    )
                    .expandedInParent()
                    .asCard()
                }
            }
        }
    }
}
