import SwiftUI

extension MasterPasswordView {
    struct LargeView: View {

        let screenWidth: CGFloat
        let isValid: Bool
        @Binding var masterPassword: String
        let saveAction: () -> Void

        @ScaledMetric private var spacing: CGFloat = 48
        @ScaledMetric private var margins: CGFloat = 16
        @ScaledMetric private var topMargin: CGFloat = 32

        var body: some View {
            HStack(alignment: .top, spacing: spacing) {
                VStack(spacing: spacing) {
                    TextField(
                        Strings.MasterPasswordView.placeholder,
                        text: $masterPassword
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(PrimaryTextFieldStyle())

                    Button(Strings.MasterPasswordView.save, action: saveAction)
                        .buttonStyle(MainButtonStyle())
                        .disabled(!isValid)
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: screenWidth / 2 - margins)

                ScrollView {
                    Label(Strings.MasterPasswordView.title)
                        .labelStyle(ParagraphStyle())
                }
            }
            .padding(margins)
            .padding(.top, topMargin)
        }
    }
}

#if DEBUG

@available(iOS 15.0, *)
struct MasterPasswordView_LargeView_Previews: PreviewProvider {

    static var previews: some View {
        GeometryReader { proxy in
            MasterPasswordView.LargeView(
                screenWidth: proxy.size.width,
                isValid: false,
                masterPassword: .constant(""),
                saveAction: {}
            )
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}

#endif
