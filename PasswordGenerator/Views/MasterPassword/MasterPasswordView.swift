import SwiftUI

struct MasterPasswordView: View {

    @ObservedObject var viewModel = ViewModel()
    
    @ScaledMetric private var spacing: CGFloat = 48
    @ScaledMetric private var margins: CGFloat = 16
    @ScaledMetric private var topMargin: CGFloat = 32

    var body: some View {

        ScrollView {

            VStack(spacing: spacing) {

                TextField(Strings.MasterPasswordView.placeholder, text: $viewModel.masterPassword)
                    .font(.system(.title, design: .monospaced))
                    .foregroundColor(.foreground)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                MainButton(action: viewModel.saveMasterPassword, text: Strings.MasterPasswordView.save)
                    .disabled(!viewModel.isValid)

                Text(Strings.MasterPasswordView.title)
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
            .padding(margins)
            .padding(.top, topMargin)
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
