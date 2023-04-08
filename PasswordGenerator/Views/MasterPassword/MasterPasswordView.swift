//swiftlint:disable closure_body_length
import SwiftUI
import ComposableArchitecture

struct MasterPasswordView: View {

    typealias ViewState = MasterPassword.State
    typealias ViewAction = MasterPassword.Action

    @ScaledMetric private var spacing: CGFloat = 48
    @ScaledMetric private var margins: CGFloat = 16
    @ScaledMetric private var topMargin: CGFloat = 32

    @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

    init(store: StoreOf<MasterPassword>) {
        self.viewStore = ViewStore(store, observe: { $0 })
    }

    var body: some View {
        ScrollView {
            VStack(spacing: spacing) {

                TextField(
                    Strings.MasterPasswordView.placeholder,
                    text: viewStore.binding(\.$masterPassword)
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(PrimaryTextFieldStyle())

                Button(Strings.MasterPasswordView.save, action: { viewStore.send(.didTapSave) })
                    .buttonStyle(MainButtonStyle())
                    .disabled(!viewStore.isValid)

                Label(Strings.MasterPasswordView.title)
                    .labelStyle(ParagraphStyle())
            }
            .padding(margins)
            .padding(.top, topMargin)
        }
        .emittingError(viewStore.binding(get: \.error, send: MasterPassword.Action.didReceiveError))
    }
}

#if DEBUG

struct MasterPasswordView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            MasterPasswordView(
                store: .init(
                    initialState: .init(),
                    reducer: MasterPassword()
                )
            )
            .environment(\.colorScheme, .light)
            .previewDisplayName("Light")

            MasterPasswordView(
                store: .init(
                    initialState: .init(),
                    reducer: MasterPassword()
                )
            )
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                MasterPasswordView(
                    store: .init(
                        initialState: .init(),
                        reducer: MasterPassword()
                    )
                )
                .environment(\.sizeCategory, category)
                .previewDisplayName("\(category)")
            }
        }
    }
}

#endif
