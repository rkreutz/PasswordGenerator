import SwiftUI

struct MasterPasswordView: View {

    @State var viewState = ViewState()

    @Environment(\.appState) private var appState
    @Environment(\.masterPasswordStorage) private var masterPasswordStorage

    @ScaledMetric private var spacing: CGFloat = 48
    @ScaledMetric private var margins: CGFloat = 16
    @ScaledMetric private var topMargin: CGFloat = 32

    var body: some View {

        ScrollView {

            VStack(spacing: spacing) {

                TextField(Strings.MasterPasswordView.placeholder, text: $viewState.masterPassword)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(PrimaryTextFiledStyle())

                Button(Strings.MasterPasswordView.save, action: saveMasterPassword)
                    .buttonStyle(MainButtonStyle())
                    .disabled(!viewState.isValid)

                Label(Strings.MasterPasswordView.title)
                    .labelStyle(ParagraphStyle())
            }
            .padding(margins)
            .padding(.top, topMargin)
        }
        .emittingError($viewState.error)
    }

    private func saveMasterPassword() {

        do {

            try masterPasswordStorage.save(masterPassword: viewState.masterPassword)
            appState.state = .masterPasswordSet
        } catch {

            viewState.error = error
        }
    }
}

#if DEBUG

struct MasterPasswordView_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            MasterPasswordView()
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")

            MasterPasswordView()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")

            ForEach(ContentSizeCategory.allCases, id: \.hashValue) { category in

                MasterPasswordView()
                    .environment(\.sizeCategory, category)
                    .previewDisplayName("\(category)")
            }
        }
        .use(masterPasswordStorage: MockMasterPasswordStorage())
        .environmentObject(AppState(state: .mustProvideMasterPassword))
    }
}

#endif
