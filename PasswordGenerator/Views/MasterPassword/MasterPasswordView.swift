import SwiftUI
import ComposableArchitecture

struct MasterPasswordView: View {

    @ScaledMetric private var spacing: CGFloat = 48
    @ScaledMetric private var margins: CGFloat = 16
    @ScaledMetric private var topMargin: CGFloat = 32

    let store: Store<State, Action>

    var body: some View {

        WithViewStore(store) { viewStore in

            ScrollView {

                VStack(spacing: spacing) {

                    TextField(
                        Strings.MasterPasswordView.placeholder,
                        text: viewStore.binding(get: \.masterPassword, send: Action.textFieldChanged)
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(PrimaryTextFieldStyle())

                    Button(Strings.MasterPasswordView.save, action: { viewStore.send(.saveMasterPassword) })
                        .buttonStyle(MainButtonStyle())
                        .disabled(!viewStore.isValid)

                    Label(Strings.MasterPasswordView.title)
                        .labelStyle(ParagraphStyle())
                }
                .padding(margins)
                .padding(.top, topMargin)
            }
            .emittingError(viewStore.binding(get: \.error, send: Action.updateError))
        }
    }
}

#if DEBUG

struct MasterPasswordView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            MasterPasswordView(
                store: .init(
                    initialState: MasterPasswordView.State(),
                    reducer: MasterPasswordView.sharedReducer,
                    environment: MasterPasswordView.Environment(masterPasswordStorage: MockMasterPasswordStorage())
                )
            )
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light")

            MasterPasswordView(
                store: .init(
                    initialState: MasterPasswordView.State(),
                    reducer: MasterPasswordView.sharedReducer,
                    environment: MasterPasswordView.Environment(masterPasswordStorage: MockMasterPasswordStorage())
                )
            )
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                MasterPasswordView(
                    store: .init(
                        initialState: MasterPasswordView.State(),
                        reducer: MasterPasswordView.sharedReducer,
                        environment: MasterPasswordView.Environment(masterPasswordStorage: MockMasterPasswordStorage())
                    )
                )
                .environment(\.sizeCategory, category)
                .previewDisplayName("\(category)")
            }
        }
    }
}

#endif
