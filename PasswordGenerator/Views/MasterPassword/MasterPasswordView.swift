import SwiftUI

struct MasterPasswordView: View {

    @ObservedObject var viewModel = ViewModel()
    
    @ScaledMetric private var spacing: CGFloat = 48
    @ScaledMetric private var margins: CGFloat = 16
    @ScaledMetric private var topMargin: CGFloat = 32
    @ScaledMetric private var maxWidth: CGFloat = 450

    var body: some View {

        ScrollView {

            VStack(spacing: spacing) {

                TextField(Strings.MasterPasswordView.placeholder, text: $viewModel.masterPassword)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(PrimaryTextFiledStyle())

                Button(Strings.MasterPasswordView.save, action: viewModel.saveMasterPassword)
                    .buttonStyle(MainButtonStyle())
                    .disabled(!viewModel.isValid)

                Label(Strings.MasterPasswordView.title)
                    .labelStyle(ParagraphStyle())
            }
            .padding(margins)
            .padding(.top, topMargin)
        }
        .frame(maxWidth: maxWidth)
        .accentColor(.accentColor)
        .background(
            Rectangle()
                .foregroundColor(.systemBackground)
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
