import SwiftUI

struct MasterPasswordView: View {

    @Environment(\.sizeCategory) private var sizeCategory

    @ObservedObject var viewModel = ViewModel()

    var body: some View {

        ScrollView {

            VStack(spacing: 48 / sizeCategory.modifier) {

                TextField(Strings.MasterPasswordView.placeholder, text: $viewModel.masterPassword)
                    .font(.system(.title, design: .monospaced))
                    .foregroundColor(.foreground)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                MainButton(
                    action: { self.viewModel.saveMasterPassword() },
                    text: Strings.MasterPasswordView.save,
                    isEnabled: viewModel.isValid
                )

                Text(Strings.MasterPasswordView.title)
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
            .padding(16 / sizeCategory.modifier)
            .padding(.top, 32 / sizeCategory.modifier)
        }
        .accentColor(.accent)
        .background(
            Rectangle()
                .foregroundColor(.background01)
                .edgesIgnoringSafeArea(.all)
        )
        .emittingError($viewModel.error)
        .injectEnvironment(into: viewModel)
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
